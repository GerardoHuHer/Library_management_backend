defmodule LibraryManagement.Repo.Migrations.CreateUsuarios do
  use Ecto.Migration

  def change do
    create table(:usuarios) do
      add :nombre, :string, null: false
      add :email, :string, null: false
      add :password, :string, null: false
    end

    create unique_index(:usuarios, [:email])
  end
end
