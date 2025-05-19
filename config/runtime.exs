# config/runtime.exs
import Config
import Dotenvy

env_dir_prefix = System.get_env("RELEASE_ROOT") || Path.expand("./envs")

source!([
  Path.absname(".env", env_dir_prefix),
  Path.absname("#{config_env()}.env", env_dir_prefix),
  System.get_env()
])

config :restapi, MyApp.Repo,
  database: env!("DATABASE", :string, "postgres"),
  username: env!("PG_USER", :string, "postgres"),
  password: env!("PASSWORD", :string, "postgres"),
  hostname: env!("HOSTNAME", :string, "localhost"),
  port: 5432
