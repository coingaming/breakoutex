defmodule Breakoutex.PersistentLeaderboard do
  use GenServer
  require Logger

  @default_db_name :leaderboard
  @leaderboard_size 50

  def start_link(table_name) do
    GenServer.start_link(__MODULE__, table_name, name: @default_db_name)
  end

  def stop(server \\ @default_db_name) do
    GenServer.stop(server)
  end

  def ping(server \\ @default_db_name) do
    case GenServer.whereis(server) do
      pid when is_pid(pid) -> {:ok, pid}
      _ -> {:error, :not_found}
    end
  end

  def init(table_name) do
    opts = [:set, :public, :named_table]
    table = PersistentEts.new(table_name, Path.expand("./leaderboard2.db"), opts)

    {:ok, %{table: table}}
  end

  def save(%{player_name: player_name, score: score, level: level, current_user_id: current_user_id}) do
    saved_info =
      {current_user_id <> "_" <> player_name,
       [score: score, time: NaiveDateTime.utc_now(), level: level, player_name: player_name]}

    # Logger.info(inspect(saved_info))
    :ets.insert(@default_db_name, saved_info)
  end

  def get_leaderboard() do
    :ets.tab2list(@default_db_name)
    |> Enum.sort_by(fn {_, [score: score, time: _, level: _, player_name: _]} -> -score end)
    |> Enum.slice(0..(@leaderboard_size - 1))
    |> Enum.with_index()
    |> Enum.into([], fn {{user, [score: score, time: time, level: level, player_name: player_name]}, index} ->
      {user, [score: score, time: time, level: level, player_name: player_name, position: index]}
    end)
  end
end
