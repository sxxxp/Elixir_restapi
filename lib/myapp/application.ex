defmodule MyApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      {Bandit, plug: MyRouter, scheme: :http, port: System.get_env("port") || 4000},
      MyApp.Repo
    ]

    :pg.start_link()
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MyApp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

defmodule MyApp.Release do
  @app :restapi

  def migrate do
    IO.inspect(priv_dir(repo, migrations_path(repo)), label: "Migration Path")

    for repo <- Application.fetch_env!(@app, :ecto_repos) do
      Ecto.Migrator.run(repo, migrations_path(repo), :up, all: true)
    end
  end

  def drop do
    for repo <- Application.fetch_env!(@app, :ecto_repos) do
      Ecto.Migrator.run(repo, migrations_path(repo), :down, all: true)
    end
  end

  def create do
    for repo <- Application.fetch_env!(@app, :ecto_repos) do
      Ecto.Adapters.Postgres.storage_up(repo.config)
    end
  end

  def rollback(repo, version) do
    Ecto.Migrator.run(repo, migrations_path(repo), :down, to: version)
  end

  defp migrations_path(repo),
    do: priv_dir(repo, "migrations")

  defp priv_dir(repo, path),
    do: Path.join([:code.priv_dir(@app), Atom.to_string(repo), path])
end
