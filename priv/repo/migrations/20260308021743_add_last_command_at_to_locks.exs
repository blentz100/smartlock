defmodule Smartlock.Repo.Migrations.AddLastCommandAtToLocks do
  use Ecto.Migration

  def change do
    alter table(:locks) do
      add :last_command_at, :utc_datetime_usec
    end
  end
end
