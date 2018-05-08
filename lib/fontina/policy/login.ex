defmodule Fontina.Policy.Login do

  alias Comeonin.Pbkdf2
  alias Fontina.{User, Token, Repo}

  def process(params) do
    params
    |> validate_email_or_username()
    |> validate_pw_match()
    |> insert_session_token()
  end
  
  defp validate_email_or_username(%{"ident" => ident} = params) do
    case String.contains?(ident, "@") do
      true -> validate_email(params)
      false -> validate_username(params)
    end
  end

  # Email
  defp validate_email(%{"ident" => email} = params) do
    case Repo.get_by(User, email: email) do
      nil  -> {:error, {:unauthorized, %{email: ["Email doesn't exist y'all"]}}}
      user -> {:ok, Map.put(params, "user", user)}
    end
  end

  # Username
  defp validate_username(%{"ident" => username} = params) do
    case Repo.get_by(User, username: username) do
      nil  -> {:error, {:unauthorized, %{username: ["user doesn't exist y'all"]}}}
      user -> {:ok, Map.put(params, "user", user)}
    end
  end

  defp validate_pw_match({:ok, %{"user" => user, "password" => pw} = params}) do
    case Pbkdf2.check_pass(user, pw) do
      {:ok, _} -> {:ok, params}
      {:error, message} -> {:error, message}
    end
  end

  defp validate_pw_match({:error, {_status, _errors} = opts}),
    do: {:error, opts}

  defp insert_session_token({:ok, %{"user" => user} = params}) do
    changeset = Token.token_changeset(%Token{}, %{user_id: user.id,
      browser: true})
    case Repo.insert(changeset) do
      {:ok, token}        -> {:ok, Map.put(params, "token", token)}
      {:error, changeset} -> {:error, {:failed_transaction, changeset}}
    end
  end

  defp insert_session_token({:error, {_status, _errors} = opts}),
    do: {:error, opts}
end
