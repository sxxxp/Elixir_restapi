import Config

config :restapi,
  ecto_repos: [MyApp.Repo]

config :pbkdf2_elixir,
  rounds: System.get_env("PBKDF2_ROUNDS", "80_000")
