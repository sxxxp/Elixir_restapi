# config/runtime.exs
import Config

config :restapi, MyApp.Repo,
  database: System.get_env("POSTGRES_DB", "postgres"),
  username: System.get_env("POSTGRES_USER", "postgres"),
  password: System.get_env("POSTGRES_PASSWORD", "postgres"),
  hostname: System.get_env("POSTGRES_HOST", "localhost"),
  port: Systme.get_env("POSTGRES_PORT", 5432)
