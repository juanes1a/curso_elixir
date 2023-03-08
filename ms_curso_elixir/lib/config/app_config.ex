defmodule MsCursoElixir.Config.AppConfig do

  @moduledoc """
   Provides strcut for app-config
  """

   defstruct [
     :enable_server,
     :http_port,
     :client_id,
     :client_secret,
     :redis_host,
     :redis_port
   ]

   def load_config do
     %__MODULE__{
       enable_server: load(:enable_server),
       http_port: load(:http_port),
       client_id: load(:client_id),
       client_secret: load(:client_secret),
       redis_host: load(:redis_host),
       redis_port: load(:redis_port)
     }
   end

   defp load(property_name), do: Application.fetch_env!(:ms_curso_elixir, property_name)
 end
