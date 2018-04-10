defmodule Fontina.Policy.Login do

  alias Authable.Utils.Crypt
  alias Authable.Model.{User, Token}
  
  @repo Application.get_env(:authable, :repo)

  def process(params) do
    params
    |> validate_email()
    |> validate_pw_match()
    |> validate_email_confirm()
    |> insert_session_token()
  end
  

  # Start Fallbacks
  defp validate_pw_match({:error, {_status, _errors} = opts}),
    do: {:error, opts}

  defp validate_email_confirm({:error, {_status, _errors} = opts}),
    do: {:error, opts}

  defp insert_session_token({:error, {_status, _errors} = opts}),
    do: {:error, opts}
  # End Fallbacks

  defp validate_email(%{"email" => email} = params) do
    case @repo.get_by(User, email: email) do
      nil  -> {:error, {:unauthorized, %{email: ["Email doesn't exist y'all"]}}}
      user -> {:ok, Map.put(params, "user", user)}
    end
  end

  defp validate_pw_match({:ok, %{"user" => user, "password" => pw} = params}) do
    case Crypt.match_password(pw, Map.get(user, :password, "")) do
      false -> {:error, {:unauthorized, %{password: ["Wrong password"]}}}
      true  -> {:ok, params}
    end
  end

  # TODO: Implement email confirmation
  defp validate_email_confirm({:ok, %{"email" => _email} = params}) do
    {:ok, params}
  end

  defp insert_session_token({:ok, %{"user" => user} = params}) do
    changeset = Token.session_token_changeset(%Token{}, %{user_id: user.id,
      details: %{"scope" => "session"}})
    case @repo.insert(changeset) do
      {:ok, token}        -> {:ok, Map.put(params, "token", token)}
      {:error, changeset} -> {:error, {:failed_transaction, changeset}}
    end
  end
end
