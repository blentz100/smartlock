defmodule Smartlock.Repo.Migrations.AddLastSeenToLocks do
  use Ecto.Migration

  def change do
    execute("""
    ALTER TABLE internal.locks
    ADD COLUMN IF NOT EXISTS last_seen_at TIMESTAMP(6) WITH TIME ZONE;
    """)
  end
end
