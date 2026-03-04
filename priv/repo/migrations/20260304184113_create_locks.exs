defmodule Smartlock.Repo.Migrations.CreateLocks do
  use Ecto.Migration

  def change do
    create table(:locks) do
      add :name, :string
      add :status, :string

      timestamps(type: :utc_datetime)
    end
  end
end
