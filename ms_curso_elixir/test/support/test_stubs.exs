defmodule TestStubs do
  alias MsCursoElixir.Domain.Model.Client


  def client_struct_complete do
    %Client{
      age: 20,
      email: "juan123@curso.com",
      last_name: "Gonzalez",
      name: "Juan Esteban"
    }
  end



end
