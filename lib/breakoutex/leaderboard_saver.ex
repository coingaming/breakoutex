defmodule Breakoutex.LeaderboardSaver do
  use GenServer

  import Ecto.Query

  @default_db_name :leaderboard
  @second 1_000
  @minute @second * 60

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    # do important stuff
    :ets.tab2list(@default_db_name)
    |> case do
      [] -> :ok
      any_result -> save_to_db(any_result)
    end

    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 5 * @minute)
  end

  defp save_to_db(res) do
    query = from("leaderboard", select: [:leaderboard])
    Breakoutex.Repo.delete_all(query)
    Breakoutex.Repo.insert_all("leaderboard", [[leaderboard: Kernel.inspect(res)]])
  end
end
