defmodule LibraryManagement.Usuarios do
  alias LibraryManagement.Repo
  alias LibraryManagement.Usuarios.Usuario

  @doc """
  Crea un nuevo usuario con los parámetros datos.
  Devuelve {:ok, usuario} si es exitoso
  Devuelve {:error, changeset} si hay errores 
  """

  def create_usuario(attrs \\ %{}) do
    %Usuario{}
    |> Usuario.changeset(attrs)
    |> Repo.insert()
  end

  def authenticate_usuario(email, password) do
    usuario = Repo.get_by(Usuario, email: email)

    case usuario do
      %Usuario{password: user_password} ->
        if password == user_password do
          {:login_exitoso, usuario}
        else
          {:contrasena_incorrecta, "La contraseña es incorrecta."}
        end

      _ ->
        :error
    end
  end

  def change_usuario(%Usuario{} = usuario, attrs \\ %{}) do
    Usuario.changeset(usuario, attrs)
  end
end
