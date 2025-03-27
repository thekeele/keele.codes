defmodule KeeleCodesWeb.Plugs.FallbackPlug do
  import Plug.Conn

  def init(options) do
    options
  end

  def call(conn, _opts) do
    conn
    |> send_resp(404, "not found")
    |> halt()
  end
end
