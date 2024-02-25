defmodule TableTennisTracker.Repo do
  use Ecto.Repo,
    otp_app: :table_tennis_tracker,
    adapter: Ecto.Adapters.Postgres
end
