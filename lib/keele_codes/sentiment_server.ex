defmodule KeeleCodes.SentimentServer do
  @moduledoc false
  use GenServer

  @model "finiteautomata/bertweet-base-sentiment-analysis"
  @tokenizer "vinai/bertweet-base"

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
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

  def handle_info({:tweet, text}, state) do
    result = Nx.Serving.run(state.serving, text)
    sentiment = form_sentiment(text, result.predictions)

    Phoenix.PubSub.broadcast(KeeleCodes.PubSub, "sentiment", {:sentiment, sentiment})

    {:noreply, state}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end

  defp form_sentiment(text, predictions) do
    predictions
    |> Enum.into(%{}, fn pred ->
      {String.downcase(pred.label), Float.round(pred.score, 2) * 100}
    end)
    |> Map.put("text", text)
  end
end
