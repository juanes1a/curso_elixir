defmodule MsCursoElixir.Infrastructure.DrivenAdapters.Redis.Client.ClientCacheTest do
  alias MsCursoElixir.Infrastructure.DrivenAdapters.Redis.Client.ClientCache

  import TestStubs
  import Mock

  use ExUnit.Case
  doctest MsCursoElixir.Application

  describe "save_client/1" do
    test "Should save client ok" do
      #Arrange
      with_mocks([
        {Redix, [], [noreply_command: fn _, _ -> :ok end]}
      ]) do
      #Act
        {status, uuid} = ClientCache.save_client(client_struct_complete())
        {uuid_status, uuid_info} = UUID.info(uuid)
      #Assert
        assert status == :ok
        assert uuid_status == :ok
      end
    end
    test "Should return couldnt save client" do
      #Arrange
      with_mocks([
        {Redix, [], [noreply_command: fn _, _ -> :error end]}
      ]) do
      #Act
        response = ClientCache.save_client(client_struct_complete())
      #Assert
        assert response == {:error, :couldnt_save_client}
      end
    end
  end
end
