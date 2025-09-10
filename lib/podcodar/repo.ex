defmodule Podcodar.Repo do
  use Ecto.Repo,
    otp_app: :podcodar,
    adapter: Ecto.Adapters.SQLite3
end
