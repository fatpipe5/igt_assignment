defmodule ClothingDashboard.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ClothingDashboardWeb.Telemetry,
      ClothingDashboard.Repo,
      {DNSCluster, query: Application.get_env(:clothing_dashboard, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ClothingDashboard.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ClothingDashboard.Finch},
      # Start a worker by calling: ClothingDashboard.Worker.start_link(arg)
      # {ClothingDashboard.Worker, arg},
      # Start to serve requests, typically the last entry
      ClothingDashboardWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ClothingDashboard.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ClothingDashboardWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
