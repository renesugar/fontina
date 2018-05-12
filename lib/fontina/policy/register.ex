defmodule Fontina.Policy.Register do

  alias Fontina.{User, Repo}

  def process(params) do
    params
    |> insert_user()
  end

  defp insert_user(%{"email" => _email,
    "password" => pw,
    "username" => _un,
    "nickname" => _nn} = params)
      when byte_size(pw) > 7 do
    changeset = User.registration_changeset(%User{}, params)

    case Repo.insert(changeset) do
      {:ok, user}        -> {:ok, Map.put(params, "user", user)}
      {:error, changeset} -> {:error, {:failed_transaction, changeset}}
    end
  end

  defp insert_user(_) do
    {:error, "pw too short"}
  end
end
