defmodule Smartlock.Repo.Migrations.AddBatteryLevelToLocks do
  use Ecto.Migration

  def change do
    alter table(:locks) do
      add :battery_level, :integer
    end
  end
end
