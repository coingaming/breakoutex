defmodule Breakoutex.PersistentLeaderboard do
  use GenServer
  require Logger
  import Ecto.Query

  @default_db_name :leaderboard
  @leaderboard_size 25

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
    Logger.info("db url: #{DATABASE_URL}")
    {:ok, %{table: table}}
  end

  def save(%{player_name: player_name, score: score, level: level, current_user_id: current_user_id}) do
    saved_info =
      {current_user_id <> "_" <> player_name,
       [score: score, time: NaiveDateTime.utc_now(), level: level, player_name: player_name]}

    # Logger.info(inspect(saved_info))
    :ets.insert(@default_db_name, saved_info)
  end

  def get_leaderboard(slice \\ true) do
    :ets.tab2list(@default_db_name)
    |> case do
      [] -> try_database()
      any_result -> any_result
    end
    |> Enum.sort_by(fn {_, [score: score, time: _, level: _, player_name: _]} -> -score end)
    |> conditional_slice(@leaderboard_size - 1, slice)
    |> Enum.with_index()
    |> Enum.into([], fn {{user, [score: score, time: time, level: level, player_name: player_name]}, index} ->
      {user, [score: score, time: time, level: level, player_name: player_name, position: index]}
    end)
  end

  def get_position(%{current_user_id: current_user_id, player_name: player_name}) do
    leaderboard = get_leaderboard(false)

    position =
      leaderboard
      |> Enum.filter(fn leaderboard_item ->
        elem(leaderboard_item, 0) == current_user_id <> "_" <> player_name
      end)
      |> hd()
      |> elem(1)
      |> Keyword.fetch!(:position)

    position + 1
  end

  defp conditional_slice(list, size, condition) do
    if condition do
      Enum.slice(list, 0..size)
    else
      list
    end
  end

  defp try_database do
    query = from("leaderboard", select: [:leaderboard])

    Breakoutex.Repo.all(query)
    |> case do
      [] ->
        []

      [%{leaderboard: leaderboard_string}] ->
        Code.eval_string(leaderboard_string)
        |> Tuple.to_list()
        |> hd()
    end
  end
end
