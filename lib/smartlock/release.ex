defmodule Smartlock.Release do
  @moduledoc """
  Used for executing DB release tasks when run in production without Mix
  installed.
  """
  @app :smartlock

  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def seed do
    start_repo()
    run_seeds()
  end

  defp start_repo do
    # Start the repo(s) manually
    Application.ensure_all_started(@app)
  end

  defp run_seeds do
    # This will actually run your priv/repo/seeds.exs
    {:ok, _} = Code.eval_file(Path.join(:code.priv_dir(@app), "repo/seeds.exs"))
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    # Many platforms require SSL when connecting to the database
    Application.ensure_all_started(:ssl)
    Application.ensure_loaded(@app)
  end
end
