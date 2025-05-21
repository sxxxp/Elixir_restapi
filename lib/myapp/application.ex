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
    start_app()

    for repo <- Application.fetch_env!(@app, :ecto_repos) do
      {:ok, _pid} = repo.start_link()
      Ecto.Migrator.run(repo, migrations_path(repo), :up, all: true)
    end
  end

  def drop do
    start_app()

    for repo <- Application.fetch_env!(@app, :ecto_repos) do
      {:ok, _pid} = repo.start_link()
      Ecto.Migrator.run(repo, migrations_path(repo), :down, all: true)
    end
  end

  def create do
    start_app()

    for repo <- Application.fetch_env!(@app, :ecto_repos) do
      {:ok, _pid} = repo.start_link()
      # 실제로는 Ecto.Adapters.SQL.query/4 등을 사용해야 할 수도 있음
      Ecto.Adapters.Postgres.storage_up(repo.config)
    end
  end

  def rollback(repo, version) do
    start_app()

    {:ok, _pid} = repo.start_link()
    Ecto.Migrator.run(repo, migrations_path(repo), :down, to: version)
  end

  defp start_app do
    Application.load(@app)
    Enum.each(Application.spec(@app, :applications), &Application.ensure_all_started/1)
  end

  defp migrations_path(repo),
    do: priv_dir(repo, "migrations")

  defp priv_dir(repo, path),
    do: Path.join([:code.priv_dir(@app), Atom.to_string(repo), path])
end
