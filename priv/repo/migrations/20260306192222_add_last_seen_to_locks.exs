defmodule Smartlock.Repo.Migrations.AddLastSeenToLocks do
  use Ecto.Migration

  def change do
    alter table(:locks) do
      add :last_seen_at, :utc_datetime_usec
    end
  end
end
