defmodule KeeleCodes.TweetStreamSimulator do
  @moduledoc false
  use GenServer

  alias KeeleCodes.XTweets

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    {:ok, state, {:continue, state}}
  end

  def handle_continue(_state, state) do
    tweets = XTweets.all()

    schedule_stream()

    {:noreply, Map.put(state, :tweets, tweets)}
  end

  def handle_info(:tweet, state) do
    state =
      case state.tweets do
        [tweet | []] ->
          Phoenix.PubSub.broadcast(KeeleCodes.PubSub, "tweets", {:tweet, tweet})
          tweets = XTweets.all()
          Map.put(state, :tweets, tweets)

        [tweet | rest] ->
          Phoenix.PubSub.broadcast(KeeleCodes.PubSub, "tweets", {:tweet, tweet})
          Map.put(state, :tweets, rest)
      end

    schedule_stream()

    {:noreply, state}
  end

  defp schedule_stream() do
    Process.send_after(self(), :tweet, :timer.seconds(5))
  end
end
