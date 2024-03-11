defmodule TableTennisTracker.Match do
  alias TableTennisTracker.Repo
  alias TableTennisTracker.Match
  alias TableTennisTracker.Game
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
    |> cast_assoc(attrs, [:games])
    |> validate_required([])
  end

  def get_all_matches() do
    Repo.all(Match)
    |> Repo.preload([:player_one, :player_two, :games])
  end

  def new_game(player_one_id, player_two_id) do
    %Match{
      player_one_id: player_one_id,
      player_two_id: player_two_id,
      games: [],
      state: :waiting_to_start,
      current_game: -1
    }
  end

  # Temporary for populating db rapidly
  def new_from(player_one_id, player_two_id, games_list) do
    games = Enum.map(games_list, fn {player_one_points, player_two_points} -> %Game{first_player_points: player_one_points, second_player_points: player_two_points} end)
    %{ new_game(player_one_id, player_two_id) | state: :finished, games: games}
  end

  def add_player_point(%Match{games: games, current_game: current_game} = match, player_number) do
    current_game = games[current_game]
    %{state: game_state} = updated_game = Game.add_player_point(current_game, player_number)
    updated_games = List.replace_at(games, current_game, updated_game)
    updated_match = %{match | games: updated_games}

    # Check whether the game finished or goes on, and whether the match ended or not
    case game_state do
      :ongoing -> updated_match
      :finished when current_game <= 5 ->
        new_set(updated_match)
      :finished ->
        %{ updated_match | state: :finished }
    end
  end

  defp new_set(%Match{games: [], state: :waiting_to_start} = match) do
    %{
      match
      | games: [Game.new_game()],
        current_game: 0,
        state: :ongoing
    }
  end
  defp new_set(%Match{games: games, current_game: current_game} = match) do
    %{
      match
      | games: [games | Game.new_game()],
        current_game: current_game + 1,
    }
  end
end
