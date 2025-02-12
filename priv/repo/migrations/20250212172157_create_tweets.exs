defmodule KeeleCodes.Repo.Migrations.CreateTweets do
  use Ecto.Migration

  def change do
    create table(:tweets) do
      add :source_name, :string
      add :source_id, :string
      add :text, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:tweets, [:source_id, :source_name])
  end
end
