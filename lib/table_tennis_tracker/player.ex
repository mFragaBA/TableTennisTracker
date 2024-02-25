defmodule TableTennisTracker.Player do
  use Ecto.Schema
  import Ecto.Changeset

  schema "players" do
    field :alias, :string
    field :ranking, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:alias, :ranking])
    |> validate_required([:alias, :ranking])
  end
end
