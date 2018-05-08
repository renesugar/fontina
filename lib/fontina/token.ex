defmodule Fontina.Token do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tokens" do
    field :user_id, :id
    field :is_browser, :boolean

    timestamps()
  end

  def token_changeset(token, attrs) do
    token
    |> cast(attrs, [:user_id, :is_browser])
    |> validate_required([:user_id, :is_browser])
  end
end
