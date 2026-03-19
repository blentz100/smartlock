defmodule Smartlock.Repo.Migrations.AddBatteryLevelToLocks do
  use Ecto.Migration

  def change do
    execute("""
    ALTER TABLE internal.locks
    ADD COLUMN IF NOT EXISTS battery_level integer;
    """)
  end
end