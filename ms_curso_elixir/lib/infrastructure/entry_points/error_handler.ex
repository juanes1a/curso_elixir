defmodule MsCursoElixir.Infrastructure.EntryPoints.ErrorHandler do

  def build_error_response(error) do
    error
    |> map_error_response()
    |> build_message_error()
  end

  defp map_error_response({:error, :client_not_authorize}) do
    %{
      code: "ERROR-01",
      detail: "El cliente no fue autorizado"
    }
  end

  defp map_error_response({:error, :invalid_idnetifier}) do
    %{
      code: "ERROR-02",
      detail: "Idenitificador no valido"
    }
  end

  defp map_error_response({:error, :client_not_exist}) do
    %{
      code: "ERROR-03",
      detail: "Cliente no encontrado"
    }
  end

  defp map_error_response(_error) do
    %{
      code: "ERROR-NN",
      detail: "Error en la aplicación, intentalo mas tarde."
    }
  end

  defp build_message_error(error_map) do
    %{
      "meta" => %{
        "messageId" => UUID.uuid4(),
        "requestDate" => get_request_date()
      },
      "data" => nil,
      "errors" => [
        error_map
      ]
    }
  end

  defp get_request_date() do
    now = DateTime.utc_now() |> Timex.to_datetime("America/Bogota")
    "#{now.day}/#{now.month}/#{now.year} #{now.hour}:#{now.minute}:#{now.second}"
  end


end
