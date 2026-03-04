defmodule Smartlock.LocksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Smartlock.Locks` context.
  """

  @doc """
  Generate a lock.
  """
  def lock_fixture(attrs \\ %{}) do
    {:ok, lock} =
      attrs
      |> Enum.into(%{
        name: "some name",
        status: "some status"
      })
      |> Smartlock.Locks.create_lock()

    lock
  end
end
