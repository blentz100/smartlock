defmodule Smartlock.Locks.Lock do
  use Ecto.Schema
  import Ecto.Changeset

  schema "locks" do
    field :name, :string
    field :status, :string
    field :last_seen_at, :utc_datetime_usec
    field :last_command_at, :utc_datetime_usec
    field :battery_level, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(lock, attrs) do
    lock
    |> cast(attrs, [:name, :status, :last_seen_at, :last_command_at, :battery_level])
    |> validate_required([:name, :status])
  end
end
