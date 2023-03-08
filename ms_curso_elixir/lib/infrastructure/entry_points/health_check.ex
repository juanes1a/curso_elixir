defmodule MsCursoElixir.Infrastructure.EntryPoint.HealthCheck do
  alias MsCursoElixir.Infrastructure.DrivenAdapters.Redis

  def checks do
    [
      %PlugCheckup.Check{name: "http", module: __MODULE__, function: :check_http}
    ]
  end

  def check_http do
    case Redis.health do
      {:ok, true} -> %{status: "up"}
      _ -> %{status: "down"}
    end
  end
end
