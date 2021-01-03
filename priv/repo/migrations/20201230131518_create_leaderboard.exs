defmodule Breakoutex.Repo.Migrations.CreateLeaderboard do
  use Ecto.Migration

  def change do
    create table(:leaderboard) do
      add(:leaderboard, :text)
    end
  end
end
