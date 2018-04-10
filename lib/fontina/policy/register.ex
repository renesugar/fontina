defmodule Fontina.Policy.Register do

  alias Authable.Model.User
  
  @repo Application.get_env(:authable, :repo)

  def process(params) do
    params
    |> insert_user()
  end

  defp insert_user(%{"email" => _email, "password" => _pw} = params) do
    changeset = User.registration_changeset(%User{}, params)

    case @repo.insert(changeset) do
      {:ok, user}        -> {:ok, Map.put(params, "user", user)}
      {:error, changeset} -> {:error, {:failed_transaction, changeset}}
    end
  end
end
