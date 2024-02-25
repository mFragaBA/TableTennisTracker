defmodule TableTennisTracker.Game do
  alias TableTennisTracker.Game
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    field :first_player_points, :integer
    field :second_player_points, :integer

    field :state, Ecto.Enum, values: [:ongoing, :finished], virtual: true
    belongs_to :match, TableTennisTracker.Match

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:first_player_points, :second_player_points])
    |> validate_required([:first_player_points, :second_player_points])
  end

  def new_game() do
    %Game{first_player_points: 0, second_player_points: 0, state: :ongoing}
  end

  def add_player_point(%Game{first_player_points: points, second_player_points: second_player_points} = game, 1) do
    %{game | first_player_points: points + 1, state: next_game_state(points + 1, second_player_points)}
  end

  def add_player_point(%Game{second_player_points: points, first_player_points: first_player_points} = game, 2) do
    %{game | second_player_points: points + 1, state: next_game_state(first_player_points, points + 1)}
  end

  defp next_game_state(first_player_points, second_player_points) when first_player_points < 11 and second_player_points < 11,  do: :ongoing
  defp next_game_state(first_player_points, second_player_points) when abs(first_player_points - second_player_points) < 2,  do: :ongoing
  defp next_game_state(_first_player_points, _second_player_points),  do: :finished
end
