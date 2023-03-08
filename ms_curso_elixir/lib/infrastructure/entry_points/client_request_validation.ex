defmodule MsCursoElixir.Infrastructure.EntryPoint.ClientRequestValidation do

  alias MsCursoElixir.Config.ConfigHolder

  require Logger

  def validate_request_body(request) when is_nil(request) do
    {:error, :data_nil}
  end

  def validate_request_body(request) when is_nil(request.data) do
    {:error, :data_nil}
  end

  def validate_request_body(request) do
    request.data
    |> List.first()
    |> case do
      nil -> {:error, :data_nil}
      body -> {:ok, body}
    end
  end

  def validate_headers(%{
    "client_id" => client_id,
    "client_secret" => client_secret
  }) do
    with {:ok, true}  <- validate_client_credentials(client_id, ConfigHolder.conf().client_id),
         {:ok, true}  <- validate_client_credentials(client_secret, ConfigHolder.conf().client_secret) do
      {:ok, true}
    else
      error ->
        Logger.error("Error validando headers #{inspect(error)}")
        error
    end
  end

  def validate_headers(_headers) do
    {:error, :client_not_authorize}
  end

  defp validate_client_credentials(request_credential, _config_credential) when is_nil(request_credential) or request_credential == "" do
    {:error, :client_not_authorize}
  end

  defp validate_client_credentials(request_credential, config_credential) do
    case String.equivalent?(request_credential, config_credential) do
      true -> {:ok, true}
      false -> {:error, :client_not_authorize}
    end
  end
end
