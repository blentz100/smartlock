defmodule Smartlock.Locks do
  @moduledoc """
  The Locks context.
  """

  alias SmartlockWeb.Endpoint

  import Ecto.Query, warn: false
  alias Smartlock.Repo

  alias Smartlock.Locks.Lock

  @doc """
  Returns the list of locks.

  ## Examples

      iex> list_locks()
      [%Lock{}, ...]

  """
  def list_locks do
    Repo.all(Lock)
  end

  @doc """
  Gets a single lock.

  Raises `Ecto.NoResultsError` if the Lock does not exist.

  ## Examples

      iex> get_lock!(123)
      %Lock{}

      iex> get_lock!(456)
      ** (Ecto.NoResultsError)

  """
  def get_lock!(id), do: Repo.get!(Lock, id)

  @doc """
  Creates a lock.

  ## Examples

      iex> create_lock(%{field: value})
      {:ok, %Lock{}}

      iex> create_lock(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_lock(attrs) do
    %Lock{}
    |> Lock.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a lock.

  ## Examples

      iex> update_lock(lock, %{field: new_value})
      {:ok, %Lock{}}

      iex> update_lock(lock, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_lock(%Lock{} = lock, attrs) do
    lock
    |> Lock.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a lock.

  ## Examples

      iex> delete_lock(lock)
      {:ok, %Lock{}}

      iex> delete_lock(lock)
      {:error, %Ecto.Changeset{}}

  """
  def delete_lock(%Lock{} = lock) do
    Repo.delete(lock)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking lock changes.

  ## Examples

      iex> change_lock(lock)
      %Ecto.Changeset{data: %Lock{}}

  """
  def change_lock(%Lock{} = lock, attrs \\ %{}) do
    Lock.changeset(lock, attrs)
  end
  def lock_lock(%Lock{} = lock) do
  {:ok, updated} = update_lock(lock, %{status: "locked"})

  Endpoint.broadcast("locks", "updated", updated)

  {:ok, updated}
  end

  def unlock_lock(%Lock{} = lock) do
  {:ok, updated} = update_lock(lock, %{status: "unlocked"})

  Endpoint.broadcast("locks", "updated", updated)

  {:ok, updated}
  end
end
