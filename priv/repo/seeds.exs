# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Smartlock.Repo.insert!(%Smartlock.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Smartlock.Locks

alias Smartlock.Locks

# Clear existing locks (optional but helpful for demo consistency)
Smartlock.Repo.delete_all(Smartlock.Locks.Lock)

door_names = [
  "Front Door",
  "Back Door",
  "Garage Entrance",
  "Pool Gate",
  "Clubhouse Door",
  "Storage Room",
  "Fitness Center",
  "Lobby Entrance",
  "Side Gate",
  "Emergency Exit",
  "Roof Door",
  "Maintenance Room",
  "Telecom Closet",
  "Elevator Machine Room",
  "Community Room",
]

statuses = ["locked", "unlocked"]

# Generate 100 entries
Enum.each(1..100, fn i ->
  name =
    Enum.random(door_names) <>
    " #" <>
    Integer.to_string(i)

  Locks.create_lock(%{
    name: name,
    status: Enum.random(statuses)
  })
end)