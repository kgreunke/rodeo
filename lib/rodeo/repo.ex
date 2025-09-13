defmodule Rodeo.Repo do
  use Ecto.Repo,
    otp_app: :rodeo,
    adapter: Ecto.Adapters.SQLite3
end
