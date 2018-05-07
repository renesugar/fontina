defmodule Fontina.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :bio, :string
    field :email, :string
    field :followers, {:array, :string}, default: []
    field :following, {:array, :string}, default: []
    field :nickname, :string
    field :username, :string
    field :pass_hash, :string
    field :password, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :nickname, :email, :bio, :following, :followers])
    |> validate_required([:username, :nickname, :email, :bio, :following, :followers])
  end
end
