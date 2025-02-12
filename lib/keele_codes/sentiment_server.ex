defmodule KeeleCodes.SentimentServer do
  @moduledoc false
  use GenServer

  @model "finiteautomata/bertweet-base-sentiment-analysis"
  @tokenizer "vinai/bertweet-base"

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    {:ok, state, {:continue, state}}
  end

  def handle_continue(_state, state) do
    with {:ok, model_info} <- Bumblebee.load_model({:hf, @model}),
         {:ok, tokenizer} <- Bumblebee.load_tokenizer({:hf, @tokenizer}) do
      serving = Bumblebee.Text.text_classification(model_info, tokenizer, top_k: 3)

      Phoenix.PubSub.subscribe(KeeleCodes.PubSub, "tweets")

      {:noreply, Map.put(state, :serving, serving)}
    else
      {:error, reason} ->
        {:stop, reason, %{}}
    end
  end

  def handle_info({:tweet, tweet}, state) do
    result = Nx.Serving.run(state.serving, tweet["text"])
    tweet_sentiment = form_tweet_sentiment(tweet, result.predictions)

    Phoenix.PubSub.broadcast(
      KeeleCodes.PubSub,
      "tweet_sentiment",
      {:tweet_sentiment, tweet_sentiment}
    )

    {:noreply, state}
  end

  defp form_tweet_sentiment(tweet, predictions) do
    sentiment = Enum.into(predictions, %{}, &{String.downcase(&1.label), trunc(&1.score * 100)})

    Map.put(tweet, "sentiment", sentiment)
  end
end
