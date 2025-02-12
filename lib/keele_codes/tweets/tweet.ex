defmodule KeeleCodes.Tweets.Tweet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tweets" do
    field :source_name, :string
    field :source_id, :string
    field :text, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(tweet, attrs) do
    tweet
    |> cast(attrs, [:source_id, :source_name, :text])
    |> validate_required([:source_id, :source_name, :text])
    |> unique_constraint([:source_id, :source_name])
  end
end
