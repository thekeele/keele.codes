defmodule XApi do
  @moduledoc false

  def recent_tweets() do
    adapter = Keyword.fetch!(config(), :adapter)

    adapter.recent_tweets()
  end

  def config() do
    Application.fetch_env!(:keele_codes, __MODULE__)
  end
end
