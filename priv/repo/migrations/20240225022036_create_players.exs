defmodule TableTennisTracker.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :alias, :string
      add :ranking, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
