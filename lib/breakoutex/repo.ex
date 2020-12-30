defmodule Breakoutex.Repo do
  use Ecto.Repo,
    otp_app: :breakoutex,
    adapter: Ecto.Adapters.Postgres
end
