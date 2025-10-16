defmodule LibraryManagement.Repo do
  use Ecto.Repo,
    otp_app: :library_management,
    adapter: Ecto.Adapters.SQLite3
end
