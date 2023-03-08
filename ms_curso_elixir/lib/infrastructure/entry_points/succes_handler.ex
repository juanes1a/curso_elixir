defmodule MsCursoElixir.Infrastructure.EntryPoints.SuccesHandler do

  def build_response(uuid) do
    %{
      "meta" => %{
        "messageId" => UUID.uuid4(),
        "requestDate" => get_request_date()
      },
      "data" => [
        %{
          "ClientUuid" => uuid
        }
      ],
      "errors" => nil
    }
  end

  def build_get_response(client) do
    %{
      "meta" => %{
        "messageId" => UUID.uuid4(),
        "requestDate" => get_request_date()
      },
      "data" => [
        client
      ],
      "errors" => nil
    }
  end

  defp get_request_date() do
    now = DateTime.utc_now() |> Timex.to_datetime("America/Bogota")
    "#{now.day}/#{now.month}/#{now.year} #{now.hour}:#{now.minute}:#{now.second}"
  end

end
