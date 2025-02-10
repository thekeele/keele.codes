defmodule KeeleCodes.Repo do
  use Ecto.Repo,
    otp_app: :keele_codes,
    adapter: Ecto.Adapters.SQLite3
end
