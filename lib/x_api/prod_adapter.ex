defmodule XApi.ProdAdapter do
  @moduledoc """
  Developer Dashboard
  https://developer.x.com/en/portal/dashboard

  Recent Tweets docs
  https://docs.x.com/x-api/posts/recent-search?playground=open
  """

  @base_url "https://api.x.com/2"

  def recent_tweets() do
    path = "/tweets/search/recent"

    url =
      (@base_url <> path)
      |> URI.parse()
      |> URI.append_query(URI.encode("query=bitcoin"))
      |> URI.append_query(URI.encode("sort_order=recency"))
      |> URI.append_query(URI.encode("tweet.fields=text"))
      |> URI.to_string()

    headers = [{"Authorization", "Bearer #{x_api_bearer_token()}"}]

    :get
    |> Finch.build(url, headers)
    |> Finch.request(KeeleCodes.Finch)
    |> handle_response()
    |> case do
      {:ok, body} -> {:ok, body["data"]}
      {:error, error} -> {:error, error}
    end
  end

  defp x_api_bearer_token() do
    :keele_codes
    |> Application.fetch_env!(XApi)
    |> Keyword.fetch!(:bearer_token)
  end

  defp handle_response({:ok, %{status: 200, body: body}}), do: {:ok, Jason.decode!(body)}
  defp handle_response({:ok, %{body: body}}), do: {:error, Jason.decode!(body)}
  defp handle_response(unexpected), do: {:error, unexpected}
end
