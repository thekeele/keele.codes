defmodule KeeleCodes.Tweets do
  @moduledoc """
  The Tweets context.
  """

  import Ecto.Query, warn: false
  alias KeeleCodes.Repo

  alias KeeleCodes.Tweets.Tweet

  def list_tweets(opts \\ []) do
    source_name = Keyword.get(opts, :source_name, "x")

    query = from t in Tweet, where: t.source_name == ^source_name

    Repo.all(query)
  end

  def get_tweet!(id), do: Repo.get!(Tweet, id)

  def delete_tweet(%Tweet{} = tweet) do
    Repo.delete(tweet)
  end
end
