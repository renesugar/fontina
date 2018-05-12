defmodule Fontina.Token do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tokens" do
    field :user_id, :id
    field :is_browser, :boolean, default: false
    field :value, :string

    timestamps()
  end

  def token_changeset(token, attrs) do
    token
    |> cast(attrs, [:user_id, :is_browser])
    |> validate_required([:user_id])
    |> put_value
    |> unique_constraint(:value)
  end

  defp put_value(changeset) do
    put_change(changeset, :value, SecureRandom.urlsafe_base64())
  end
end
