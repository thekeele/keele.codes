defmodule KeeleCodes.XTweets do
  @moduledoc false

  import Ecto.Query, warn: false
  alias KeeleCodes.Repo

  alias KeeleCodes.Tweets
  alias KeeleCodes.Tweets.Tweet

  def all() do
    Tweets.list_tweets(source_name: "x")
    |> Enum.map(fn tweet ->
      %{
        "id" => tweet.source_id,
        "text" => tweet.text
      }
    end)
  end

  def create_recent_tweets() do
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    case XApi.recent_tweets() do
      {:ok, recent_tweets} ->
        tweets =
          Enum.map(recent_tweets, fn tweet ->
            %{
              source_name: "x",
              source_id: tweet["id"],
              text: tweet["text"],
              inserted_at: now,
              updated_at: now
            }
          end)

        Repo.insert_all(Tweet, tweets, on_conflict: :nothing)
        :ok

      {:error, error} ->
        {:error, error}
    end
  end
end
