defmodule MsCursoElixir.Infrastructure.EntryPoint.ApiRest do

  @moduledoc """
  Access point to the rest exposed services
  """
  alias MsCursoElixir.Utils.DataTypeUtils
  alias MsCursoElixir.Infrastructure.EntryPoints.ErrorHandler
  alias MsCursoElixir.Infrastructure.EntryPoint.ClientRequestValidation
  alias MsCursoElixir.Domain.Model.Client
  alias MsCursoElixir.Domain.UseCases.Client.ClientUsecase
  alias MsCursoElixir.Infrastructure.EntryPoints.SuccesHandler
  require Logger
  use Plug.Router
  use Timex

  plug(CORSPlug,
    methods: ["GET", "POST", "PUT", "DELETE"],
    origin: [~r/.*/],
    headers: ["Content-Type", "Accept", "User-Agent"]
  )

  plug(Plug.Logger, log: :debug)
  plug(:match)
  plug OpentelemetryPlug.Propagation
  plug(Plug.Parsers, parsers: [:urlencoded, :json], json_decoder: Poison)
  plug(Plug.Telemetry, event_prefix: [:ms_curso_elixir, :plug])
  plug(:dispatch)

  forward(
    "/ms_curso_elixir/api/health",
    to: PlugCheckup,
    init_opts: PlugCheckup.Options.new(json_encoder: Jason, checks: MsCursoElixir.Infrastructure.EntryPoint.HealthCheck.checks)
  )

  get "/ms_curso_elixir/api/hello/" do
    Logger.info("Este es un log de informacion")
    build_response("Hello World", conn)
  end

  post "/ms_curso_elixir/api/clientRegistration" do
    try do
      with request <- conn.body_params |> DataTypeUtils.normalize(),
           headers <- conn.req_headers |> DataTypeUtils.normalize_headers(),
           {:ok, body} <- ClientRequestValidation.validate_request_body(request),
           {:ok, true} <- ClientRequestValidation.validate_headers(headers),
           {:ok, client} <- Client.create_client_struct(body) |> IO.inspect(),
           {:ok, uuid} <- ClientUsecase.register_client(client) do
            SuccesHandler.build_response(uuid)
            |> build_response(conn)
      else
        error ->
          Logger.error("Error en el controlador #{inspect(error)}")
          response = ErrorHandler.build_error_response(error)
          build_response(%{status: 400, body: response}, conn)
      end
    rescue
      error ->
        IO.inspect(error)
        handle_error(error, conn)
    end

  end

  post "/ms_curso_elixir/api/getClient" do
    try do
      with request <- conn.body_params |> DataTypeUtils.normalize(),
           headers <- conn.req_headers |> DataTypeUtils.normalize_headers(),
           {:ok, body} <- ClientRequestValidation.validate_request_body(request),
           {:ok, true} <- ClientRequestValidation.validate_headers(headers),
           {:ok, uuid} <- ClientUsecase.get_client(body.uuid) do
            SuccesHandler.build_response(uuid)
            |> build_response(conn)
      else
        error ->
          Logger.error("Error en el controlador #{inspect(error)}")
          response = ErrorHandler.build_error_response(error)
          build_response(%{status: 400, body: response}, conn)
      end
    rescue
      error ->
        IO.inspect(error)
        handle_error(error, conn)
    end

  end


  def build_response(%{status: status, body: body}, conn) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Poison.encode!(body))
  end

  def build_response(response, conn), do: build_response(%{status: 200, body: response}, conn)

  match _ do
    conn
    |> handle_not_found(Logger.level())
  end

  defp handle_error(error, conn) do
    error
    |> build_response(conn)
  end

  defp handle_bad_request(error, conn) do
    error
    |> build_bad_request_response(conn)
  end

  defp build_bad_request_response(response, conn) do
    build_response(%{status: 400, body: response}, conn)
  end

  defp handle_not_found(conn, :debug) do
    %{request_path: path} = conn
    body = Poison.encode!(%{status: 404, path: path})
    send_resp(conn, 404, body)
  end

  defp handle_not_found(conn, _level) do
    send_resp(conn, 404, "")
  end
end
