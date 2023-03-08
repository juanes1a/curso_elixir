import Config

config :ms_curso_elixir, timezone: "America/Bogota"

config :ms_curso_elixir,
  http_port: 8083,
  enable_server: true,
  secret_name: "",
  version: "0.0.1",
  in_test: false,
  custom_metrics_prefix_name: "ms_curso_elixir"

config :logger,
  level: :warning

config :ms_curso_elixir,
  client_id: "123456",
  client_secret: "qwerty"

config :ms_curso_elixir,
  redis_host: "localhost",
  redis_port: "6379"

config :ms_curso_elixir,
  client_repository: MsCursoElixir.Infrastructure.DrivenAdapters.Redis.Client.ClientCache

# tracer
config :opentelemetry,
  span_processor: :batch,
  traces_exporter: :otlp

config :opentelemetry_exporter,
  otlp_protocol: :http_protobuf,
  otlp_endpoint: "http://localhost:4318"
