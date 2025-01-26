defmodule ClothingDashboard.LiveFeed do
  alias Phoenix.PubSub

  @topic "live_feed"

  def broadcast_update(update) do
    PubSub.broadcast(ClothingDashboard.PubSub, @topic, {:new_update, update})
  end

  def subscribe() do
    PubSub.subscribe(ClothingDashboard.PubSub, @topic)
  end
end
