defmodule Smartlock.Repo do
  use Ecto.Repo,
    otp_app: :smartlock,
    adapter: Ecto.Adapters.Postgres
end
