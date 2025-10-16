defmodule LibraryManagementWeb.UserController do
  use LibraryManagementWeb, :controller

  alias LibraryManagement.Usuarios

  def create(conn, %{"usuario" => user_params}) do
    case(Usuarios.create_usuario(user_params)) do
      {:ok, usuario} ->
        conn
        |> put_status(:created)
        |> render(:show, usuario: usuario)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:error, changeset: changeset)
    end
  end

  def login_user(conn, %{"usuario" => %{"email" => email, "password" => password}}) do
    case Usuarios.authenticate_usuario(email, password) do
      {:login_exitoso, user} ->
        conn
        |> put_status(:ok)
        |> render(:login_exitoso, %{
          message: "Inicio de sesión exitoso. ",
          user_id: user.id
        })

      {:contrasena_incorrecta, message} ->
        conn
        |> put_status(:ok)
        |> render(:contrasena_incorrecta, %{message: message})

      :error ->
        conn
        |> put_status(:ok)
        |> render(:invalid_credentials, %{message: "Las credenciales no existen"})
    end
  end
end
