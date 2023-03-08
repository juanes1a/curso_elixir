defmodule MsCursoElixir.Infrastructure.DrivenAdapters.Redis.Client.ClientCache do
  alias MsCursoElixir.Domain.Behaviours.Client.ClientRepositoryBehaviour
  alias MsCursoElixir.Utils.DataTypeUtils

  @behaviour ClientRepositoryBehaviour

  def save_client(client) do
    encode_client = Poison.encode!(client)
    uuid = UUID.uuid4()
    Redix.noreply_command(:redix, ["SET", uuid, encode_client]) |> IO.inspect() |> extract_noreply(uuid)
  end

  def get_client(uuid) do
    Redix.command(:redix, ["GET", uuid]) |> extract()
  end

  defp extract(response) do
    case response do
      {:ok, nil} -> {:error, :client_not_exist}
      {:ok, 0} -> {:error, :client_not_exist}
      {:ok, response} -> {:ok, Poison.decode!(response) |> DataTypeUtils.normalize() }
      other -> other
    end
  end

  defp extract_noreply(response, uuid) do
    case response do
      :ok -> {:ok, uuid}
      _ -> {:error, :couldnt_save_client}

    end
  end


end
