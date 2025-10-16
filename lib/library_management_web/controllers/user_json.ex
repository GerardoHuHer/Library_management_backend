defmodule LibraryManagementWeb.UserJSON do
  import Ecto.Changeset, only: [traverse_errors: 2]

  def show(%{usuario: usuario}) do
    %{data: usuario(usuario)}
  end

  def usuario(%{id: id, nombre: nombre, email: email}) do
    %{
      id: id,
      nombre: nombre,
      email: email
    }
  end

  def render("login_exitoso.json", %{message: message, user_id: user_id}) do
    %{
      data: %{
        status: 200,
        message: message,
        user_id: user_id
      }
    }
  end

  def render("contrasena_incorrecta.json", %{message: message}) do
    %{
      errors: %{status: 401, message: message, user_id: 0}
    }
  end

  def render("invalid_credentials.json", %{message: message}) do
    %{
      errors: %{
        status: 401,
        message: message,
        user_id: 0
      }
    }
  end

  def render("error.json", %{changeset: changeset}) do
    # Traducimos los errores del changeset a un mapa de campos/mensajes.
    errors =
      traverse_errors(changeset, fn {msg, opts} ->
        Regex.replace(~r"%{(\w+)}", msg, fn _match, key ->
          opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
        end)
      end)

    # Lógica para detectar el error de unicidad en el email
    if errors[:email] do
      message_list = List.wrap(errors[:email])

      # Buscamos si el error de email contiene el mensaje típico de unicidad ("ya ha sido tomado")
      if Enum.any?(message_list, &String.contains?(&1, "ha sido tomado")) do
        # Si es un error de unicidad, devolvemos el mensaje amigable
        %{
          errors: %{
            status: 422,
            detail: "Usuario existente. Este correo ya está registrado."
          }
        }
      else
        # Si es otro error de validación (ej. formato), devolvemos el error específico
        %{
          errors: %{
            status: 422,
            details: errors
          }
        }
      end
    else
      # Devolvemos todos los errores si el error no es específico del email
      %{
        errors: %{
          status: 422,
          details: errors
        }
      }
    end
  end
end
