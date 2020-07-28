defmodule BookGame.Repo do
  use Ecto.Repo,
    otp_app: :bookgame,
    adapter: Ecto.Adapters.Postgres
end
