defmodule TableTennisTracker.Match do
  alias TableTennisTracker.Match
  alias TableTennisTracker.Game
  alias TableTennisTracker.Player
  use Ecto.Schema
  import Ecto.Changeset

  schema "matches" do
    belongs_to :player_one, TableTennisTracker.Player
    belongs_to :player_two, TableTennisTracker.Player

    field :state, Ecto.Enum, values: [:waiting_to_start, :ongoing, :finished], virtual: true
    field :current_game, :integer, virtual: true

    has_many :games, TableTennisTracker.Game

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(match, attrs) do
    match
    |> cast(attrs, [])
    |> validate_required([])
  end

  def new_game(%Player{id: player_one_id}, %Player{id: player_two_id}) do
    %Match{
      player_one_id: player_one_id,
      player_two_id: player_two_id,
      games: [],
      state: :waiting_to_start,
      current_game: -1
    }
  end

  def new_set(%Match{games: games, current_game: current_game, state: state} = match) do
    %{
      match
      | games: [games | Game.new_game()],
        current_game: current_game + 1,
        state: next_game_state(current_game + 1, state)
    }
  end

  defp next_game_state(_, :waiting_to_start), do: :ongoing
  defp next_game_state(5, :ongoing), do: :finished
  defp next_game_state(_game_number, :ongoing), do: :ongoing
end
