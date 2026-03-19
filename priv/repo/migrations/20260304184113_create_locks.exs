defmodule Smartlock.Repo.Migrations.CreateLocks do
  use Ecto.Migration

  def change do
    execute("""
    CREATE TABLE IF NOT EXISTS internal.locks (
      id serial PRIMARY KEY,
      name varchar,
      status varchar,
      inserted_at timestamp,
      updated_at timestamp
    );
    """)
  end
end