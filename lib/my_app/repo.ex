defmodule MyApp.Repo do
  use Ecto.Repo,
    otp_app: :restapi,
    adapter: Ecto.Adapters.Postgres
end
