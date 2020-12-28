defmodule BreakoutexWeb.Components.ActiveUsers do
  use BreakoutexWeb, :live_component

  @moduledoc """
    A small LiveView that shows the active players of the game
  """

  def render(assigns) do
    ~L"""
      <h6>Users online:</h6>
      <div class="grid-container">
        <div class="grid-item grid-header">
          Name
        </div>
        <div class="grid-item grid-header">
          Level
        </div>
        <div class="grid-item grid-header">
          Points
        </div>
        <%= for {user_id, user} <- @users do %>
          <div class="grid-item">
            <%= if user_id == @current_user_id do %>
              <span class="me"><%= user[:name] %></span>
            <% else %>
              <%= user[:name] %>
            <% end %>
          </div>
          <div class="grid-item">
          <%= user[:level] %>
          </div>
          <div class="grid-item">
            <%= user[:points] %>
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
