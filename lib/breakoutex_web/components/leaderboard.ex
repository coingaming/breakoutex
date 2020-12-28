defmodule BreakoutexWeb.Components.Leaderboard do
  use BreakoutexWeb, :live_component

  @moduledoc """
    A small LiveView that shows the leaderboard of the game
  """

  def render(assigns) do
    ~L"""
      <h6>Top 50:</h6>
      <div class="grid-container-leaderboard">
        <div class="grid-item grid-header">
          #
        </div>
        <div class="grid-item grid-header">
          Name
        </div>
        <div class="grid-item grid-header">
          Time
        </div>
        <div class="grid-item grid-header">
          Lvl
        </div>
        <div class="grid-item grid-header">
          Points
        </div>
        <%= for {user_id, user} <- @leaderboard do %>
          <div class="grid-item">
            1.
          </div>
          <div class="grid-item">
            <%= if user_id == @current_user_id do %>
              <span class="me"><%= user[:player_name] %></span>
            <% else %>
              <%= user[:player_name] %>
            <% end %>
          </div>
          <div class="grid-item">
            <%= user[:time].year %>-<%= user[:time].month %>-<%= user[:time].day %> <%= user[:time].hour %>:<%= user[:time].minute %>
          </div>
          <div class="grid-item">
            <%= user[:level] + 1 %>
          </div>
          <div class="grid-item">
            <%= user[:score] %>
          </div>
        <% end %>
      </div>
    """
  end

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)}
  end
end
