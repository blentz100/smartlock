defmodule Smartlock.Locks.Lock do
  use Ecto.Schema
  import Ecto.Changeset

  schema "locks" do
    field :name, :string
    field :status, :string
    field :last_seen_at, :utc_datetime_usec

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(lock, attrs) do
    lock
    |> cast(attrs, [:name, :status, :last_seen_at])
    |> validate_required([:name, :status])
  end
end
