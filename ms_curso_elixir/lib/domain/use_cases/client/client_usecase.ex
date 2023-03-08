defmodule MsCursoElixir.Domain.UseCases.Client.ClientUsecase do

  alias MsCursoElixir.Domain.Model.Client
  require Logger

  @client_repository Application.compile_env(:ms_curso_elixir, :client_repository)

  def register_client(%Client{} = client) do
    with {:ok, true} <- Client.validate_client_data(client),
        {:ok, uuid} <- @client_repository.save_client(client)  do
      {:ok, uuid}
    else
      error ->
        Logger.error("Error en caso de uso #{inspect(error)}")
        error
    end
  end

  def get_client(uuid) do
    with {:ok, true} <- validate_client_identifier(uuid),
        {:ok, client} <- @client_repository.get_client(uuid)  do
      {:ok, client}
    else
      error ->
        Logger.error("Error en caso de uso #{inspect(error)}")
        error
    end
  end

  defp validate_client_identifier(uuid) do
    case UUID.info(uuid) do
      {:ok, _result} -> {:ok, true}
      {:error, _} -> {:error, :invalid_idnetifier}
    end
  end
end
