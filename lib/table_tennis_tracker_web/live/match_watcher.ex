defmodule TableTennisTrackerWeb.MatchWatcherLive do
  # In Phoenix v1.6+ apps, the line is typically: use MyAppWeb, :live_view
  use Phoenix.LiveView

  def render(assigns) do
    ~H"""
    <table class="w-full text-sm text-left rtl:text-right text-gray-500 dark:text-gray-400">
      <thead class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
        <tr>
          <th scope="col" class="px-6 py-3">First Player</th>
          <th scope="col" class="px-6 py-3">Second Player</th>
          <th scope="col" class="px-6 py-3">First Game</th>
          <th scope="col" class="px-6 py-3">Second Game</th>
          <th scope="col" class="px-6 py-3">Third Game</th>
          <th scope="col" class="px-6 py-3">Fourth Game</th>
          <th scope="col" class="px-6 py-3">Fifth Game</th>
        </tr>
      </thead>
      <tbody>
        <%= for match <- @matches do %>
              <tr class="bg-white border-b dark:bg-gray-800 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600">
                <th scope="row" class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap dark:text-white"><%= match.player_one.alias %></th>
                <td class="px-6 py-4"><%= match.player_two.alias %></td>
                <%= for game_num <- 0..4 do %>
                  <td class="px-6 py-4"><%= Map.get(Enum.at(match.games , game_num) || %{}, :first_player_points) %> - <%= Map.get(Enum.at(match.games , game_num) || %{}, :second_player_points) %></td>
                <% end %>
              </tr>
        <% end %>
      </tbody>
    </table>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :matches, TableTennisTracker.Match.get_all_matches())}
  end
end
