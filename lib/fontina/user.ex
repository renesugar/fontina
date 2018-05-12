defmodule Fontina.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Comeonin.Pbkdf2

  # TODO: Add domain field
  # If domain = nil, user is local
  # id = $username@$domain
  schema "users" do
    field :bio, :string, default: ""
    field :email, :string
    field :nickname, :string
    field :username, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    timestamps()
  end

  def registration_changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :nickname, :email, :password])
    |> unique_constraint(:username)
    |> unique_constraint(:email)
    |> validate_required([:username, :nickname, :email, :password])
    |> validate_password
    |> hash_password
  end

  # TODO: Add password validation ( >8 characters, etc, maybe use not_qwerty123 )
  defp validate_password(changeset),
    do: changeset

  # Nils out the password entry and adds the password_hash entry
  defp hash_password(changeset) do
    change(changeset, Pbkdf2.add_hash(changeset.changes.password))
  end
end
