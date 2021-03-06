defmodule Breakoutex.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Breakoutex.Repo,
      BreakoutexWeb.Endpoint,
      {Breakoutex.PersistentLeaderboard, :leaderboard},
      {Phoenix.PubSub, [adapter: Phoenix.PubSub.PG2, pool_size: 1, name: Breakoutex.PubSub]},
      BreakoutexWeb.Presence,
      Breakoutex.LeaderboardSaver
    ]

    opts = [strategy: :one_for_one, name: Breakoutex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    BreakoutexWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
