defmodule TableTennisTracker.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :first_player_points, :integer
      add :second_player_points, :integer
      add :match_id, references(:matches, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:games, [:match_id])
  end
end
