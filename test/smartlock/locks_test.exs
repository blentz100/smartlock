defmodule Smartlock.LocksTest do
  use Smartlock.DataCase

  alias Smartlock.Locks

  describe "locks" do
    alias Smartlock.Locks.Lock

    import Smartlock.LocksFixtures

    @invalid_attrs %{name: nil, status: nil}

    test "list_locks/0 returns all locks" do
      lock = lock_fixture()
      assert Locks.list_locks() == [lock]
    end

    test "get_lock!/1 returns the lock with given id" do
      lock = lock_fixture()
      assert Locks.get_lock!(lock.id) == lock
    end

    test "create_lock/1 with valid data creates a lock" do
      valid_attrs = %{name: "some name", status: "some status"}

      assert {:ok, %Lock{} = lock} = Locks.create_lock(valid_attrs)
      assert lock.name == "some name"
      assert lock.status == "some status"
    end

    test "create_lock/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Locks.create_lock(@invalid_attrs)
    end

    test "update_lock/2 with valid data updates the lock" do
      lock = lock_fixture()
      update_attrs = %{name: "some updated name", status: "some updated status"}

      assert {:ok, %Lock{} = lock} = Locks.update_lock(lock, update_attrs)
      assert lock.name == "some updated name"
      assert lock.status == "some updated status"
    end

    test "update_lock/2 with invalid data returns error changeset" do
      lock = lock_fixture()
      assert {:error, %Ecto.Changeset{}} = Locks.update_lock(lock, @invalid_attrs)
      assert lock == Locks.get_lock!(lock.id)
    end

    test "delete_lock/1 deletes the lock" do
      lock = lock_fixture()
      assert {:ok, %Lock{}} = Locks.delete_lock(lock)
      assert_raise Ecto.NoResultsError, fn -> Locks.get_lock!(lock.id) end
    end

    test "change_lock/1 returns a lock changeset" do
      lock = lock_fixture()
      assert %Ecto.Changeset{} = Locks.change_lock(lock)
    end
  end
end
