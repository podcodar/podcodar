defmodule Website.Repo do
  use Ecto.Repo,
    otp_app: :website,
    adapter: Ecto.Adapters.Postgres
end
