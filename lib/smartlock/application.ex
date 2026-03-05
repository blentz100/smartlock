defmodule Smartlock.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SmartlockWeb.Telemetry,
      Smartlock.Repo,
      {DNSCluster, query: Application.get_env(:smartlock, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Smartlock.PubSub},
      # Start a worker by calling: Smartlock.Worker.start_link(arg)
      # {Smartlock.Worker, arg},
      # Start to serve requests, typically the last entry
      SmartlockWeb.Endpoint,
      Smartlock.IoT.LockSimulator
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Smartlock.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SmartlockWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
