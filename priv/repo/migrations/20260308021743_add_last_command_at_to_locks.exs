defmodule Smartlock.Repo.Migrations.AddLastCommandAtToLocks do
  use Ecto.Migration

  def change do
    execute("""
    ALTER TABLE internal.locks
    ADD COLUMN IF NOT EXISTS last_command_at TIMESTAMP(6) WITH TIME ZONE;
    """)
  end
end