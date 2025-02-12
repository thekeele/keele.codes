defmodule KeeleCodesWeb.DojoLive do
  use KeeleCodesWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(KeeleCodes.PubSub, "tweet_sentiment")
    end

    socket =
      socket
      |> assign(:topic_sentiment, %{tweets: [], pos: 0, neu: 0, neg: 0})
      |> assign(:tweet_sentiment, nil)

    {:ok, socket}
  end

  def handle_info({:tweet_sentiment, tweet_sentiment}, socket) do
    topic_sentiment = socket.assigns.topic_sentiment

    topic_sentiment =
      if tweet_sentiment["id"] not in topic_sentiment.tweets do
        topic_sentiment = Map.update!(topic_sentiment, :tweets, &[tweet_sentiment["id"] | &1])

        case tweet_text_prediction(tweet_sentiment) do
          "pos" -> Map.update!(topic_sentiment, :pos, &(&1 + 1))
          "neu" -> Map.update!(topic_sentiment, :neu, &(&1 + 1))
          "neg" -> Map.update!(topic_sentiment, :neg, &(&1 + 1))
        end
      else
        topic_sentiment
      end

    socket =
      socket
      |> assign(:topic_sentiment, topic_sentiment)
      |> assign(:tweet_sentiment, tweet_sentiment)

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="flex flex-col gap-y-8">
      <div class="flex flex-row max-md:flex-col justify-around items-center gap-y-8">
        <.profile_pic />
        <.code_links />
        <.career_links />
        <.contact_links />
      </div>
      <.topic_sentiment topic_sentiment={@topic_sentiment} tweet_sentiment={@tweet_sentiment} />
      <.tweet_sentiment :if={@tweet_sentiment} tweet_sentiment={@tweet_sentiment} />
    </div>
    """
  end

  defp profile_pic(assigns) do
    ~H"""
    <a href="https://www.flickr.com/photos/supercoldskater/">
      <img class="w-36 h-36 rounded-xl" src={~p"/images/mark.jpeg"} />
    </a>
    """
  end

  defp code_links(assigns) do
    ~H"""
    <div class="flex flex-col justify-center">
      <a href="https://github.com/thekeele" class="font-mono text-4xl text-sky-600 hover:text-sky-800">
        github
      </a>
      <a
        href="https://exercism.io/profiles/thekeele"
        class="font-mono text-4xl text-sky-600 hover:text-sky-800"
      >
        exercism
      </a>
    </div>
    """
  end

  defp career_links(assigns) do
    ~H"""
    <div class="flex flex-col justify-center">
      <a href="https://keele.codes/resume" class="font-mono text-4xl text-sky-600 hover:text-sky-800">
        résumé
      </a>
      <a
        href="https://www.linkedin.com/in/thekeele"
        class="font-mono text-4xl text-sky-600 hover:text-sky-800"
      >
        linkedin
      </a>
    </div>
    """
  end

  defp contact_links(assigns) do
    ~H"""
    <div class="flex flex-col justify-center">
      <a href="mailto:mark@keele.codes" class="font-mono text-lg text-white hover:text-gray-600">
        <.icon name="hero-envelope-solid" class="w-8 h-8 bg-white" /> mark@keele.codes
      </a>
      <div class="flex flex-row justify-between items-center">
        <a href="https://www.instagram.com/markiepooshreds/">
          <img class="w-8 h-5 rounded-sm" src={~p"/images/logo.png"} />
        </a>

        <p class="font-mono text-2xl dark:text-gray-600">made w/</p>

        <a href="https://keele.codes/bitcoin">
          <.icon name="hero-heart-solid" class="w-7 h-7 bg-red-600 hover:bg-orange-600" />
        </a>
      </div>
    </div>
    """
  end

  defp topic_sentiment(%{tweet_sentiment: nil} = assigns) do
    ~H"""
    <div class="flex flex-row justify-around">
      <p class="font-mono text-lg text-white">loading bitcoin sentiment</p>
      <.icon name="hero-arrow-path" class="w-8 h-8 animate-spin bg-white" />
    </div>
    """
  end

  defp topic_sentiment(assigns) do
    ~H"""
    <div class="flex flex-row justify-around">
      <p class="font-mono text-lg text-white">topic bitcoin</p>
      <p class="font-mono text-lg text-sky-600">{length(@topic_sentiment.tweets)} tweets</p>
      <p class={"font-mono text-lg #{sentiment_color("pos")}"}>
        {trunc(@topic_sentiment.pos / length(@topic_sentiment.tweets) * 100)}% pos
      </p>
      <p class={"font-mono text-lg #{sentiment_color("neu")}"}>
        {trunc(@topic_sentiment.neu / length(@topic_sentiment.tweets) * 100)}% neu
      </p>
      <p class={"font-mono text-lg #{sentiment_color("neg")}"}>
        {trunc(@topic_sentiment.neg / length(@topic_sentiment.tweets) * 100)}% neg
      </p>
    </div>
    """
  end

  defp tweet_sentiment(assigns) do
    assigns =
      assigns
      |> assign_new(:sorted_sentiment, fn ->
        Enum.sort_by(assigns.tweet_sentiment["sentiment"], &elem(&1, 1), :desc)
      end)
      |> assign_new(:text_label, fn ->
        tweet_text_prediction(assigns.tweet_sentiment)
      end)

    ~H"""
    <div class="flex flex-col">
      <div class="flex flex-row justify-center max-md:justify-around gap-x-4">
        <%= for {label, score} <- @sorted_sentiment do %>
          <p class={"font-mono text-lg #{sentiment_color(label)}"}>{score}% {label}</p>
        <% end %>
      </div>

      <div class="flex flex-row justify-center p-4">
        <p class={"font-mono text-lg text-pretty #{sentiment_color(@text_label)}"}>
          {@tweet_sentiment["text"]}
        </p>
      </div>
    </div>
    """
  end

  defp tweet_text_prediction(%{"sentiment" => sentiment}) do
    sentiment
    |> Enum.max_by(&elem(&1, 1))
    |> elem(0)
  end

  defp sentiment_color("pos"), do: "text-green-600"
  defp sentiment_color("neu"), do: "text-yellow-600"
  defp sentiment_color("neg"), do: "text-red-600"
end
