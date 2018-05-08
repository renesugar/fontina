defmodule Fontina.Policy.Register do

  alias Fontina.{User, Repo}

  def process(params) do
    params
    |> insert_user()
  end

  defp insert_user(%{"email" => _email,
    "password" => _pw,
    "username" => _un,
    "nickname" => _nn
  } = params) do
    changeset = User.registration_changeset(%User{}, params)

    case Repo.insert(changeset) do
      {:ok, user}        -> {:ok, Map.put(params, "user", user)}
      {:error, changeset} -> {:error, {:failed_transaction, changeset}}
    end
  end
end
