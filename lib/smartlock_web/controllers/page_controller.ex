defmodule SmartlockWeb.PageController do
  use SmartlockWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
