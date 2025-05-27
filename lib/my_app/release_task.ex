defmodule MyApp.ReleaseTask do
  require Logger

  def migrate do
    load_app()

    for repo <- repos() do
      ensure_repo_created(repo)
      run_migrations(repo)
    end
  end

  defp ensure_repo_created(repo) do
    case repo.__adapter__.storage_up(repo.config) do
      :ok ->
        Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :create, all: true))
        Logger.info("Database for #{inspect(repo)} created successfully.")

      {:error, :already_up} ->
        Logger.info("Database for #{inspect(repo)} already exists.")

      {:error, term} ->
        Logger.error("Failed to create database for #{inspect(repo)}: #{inspect(term)}")
        exit(1)
    end
  end

  defp run_migrations(repo) do
    Logger.info("Running migrations for #{inspect(repo)}...")
    Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
  end

  defp repos do
    Application.get_env(:my_app, :ecto_repos, [])
  end

  defp load_app do
    Application.load(:my_app)
  end
end
