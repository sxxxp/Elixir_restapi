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

defmodule MyApp.ReleaseTasks do
  @start_apps [
    :crypto,
    :ssl,
    :postgrex,
    :ecto
  ]

  def migrate do
    start_dependencies()
    run_migrations()
    stop_dependencies()
  end

  def drop do
    start_dependencies()
    run_drop()
    stop_dependencies()
  end

  defp start_dependencies do
    Enum.each(@start_apps, &Application.ensure_all_started/1)
  end

  defp run_migrations do
    path = Application.app_dir(:restapi, "priv/repo/migrations")
    Ecto.Migrator.run(YourApp.Repo, path, :up, all: true)
  end

  defp run_drop do
    path = Application.app_dir(:restapi, "priv/repo/migrations")
    Ecto.Migrator.run(YourApp.Repo, path, :down, all: true)
  end

  defp stop_dependencies do
    :init.stop()
  end
end
