defmodule LibraryManagement.Usuarios.Usuario do
  use Ecto.Schema
  import Ecto.Changeset

  schema "usuarios" do
    field :nombre, :string
    field :email, :string
    field :password, :string
  end

  @required_params [:nombre, :email, :password]
  def changeset(usuario, params) do
    usuario
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    # Con este constraint nos aseguramos que el email sea único en la base
    |> unique_constraint(:email, name: :usuarios_email_index)
  end
end
