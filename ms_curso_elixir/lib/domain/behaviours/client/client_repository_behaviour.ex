defmodule MsCursoElixir.Domain.Behaviours.Client.ClientRepositoryBehaviour do

  @callback save_client(client::term) :: {:ok, uuid :: term} | {:error, reason :: term}
  @callback get_client(uuid::term) :: {:ok, client :: term} | {:error, reason :: term}


end
