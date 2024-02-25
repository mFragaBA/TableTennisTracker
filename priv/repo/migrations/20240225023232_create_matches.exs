defmodule TableTennisTracker.Repo.Migrations.CreateMatches do
  use Ecto.Migration

  def change do
    create table(:matches) do
      add :player_one_id, references(:players, on_delete: :nothing)
      add :player_two_id, references(:players, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:matches, [:player_one_id])
    create index(:matches, [:player_two_id])
  end
end
