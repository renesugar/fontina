defmodule Fontina.Follow do
  use Ecto.Schema
  import Ecto.Changeset

  import Fontina.{User, Repo}

  schema "follows" do
    field :follower_id, :id
    field :followee_id, :id

    timestamps()
  end

  @doc false
  def changeset(follow, attrs) do
    follow
    |> cast(attrs, [:follower_id, :followee_id])
    |> unique_constraint(:follower_id, name: :follows_follower_id_followee_id_index) # The combination of these two has to be unique, so name mangling is required ^^'
    |> validate_required([:follower_id, :followee_id])
  end

  # TODO: make these error better
  def follow(%User{id: follower_id} = _follower, %User{id: followee_id} = _followee) do
    %Follow{}
    |> changeset(%{follower_id: follower_id, followee_id: followee_id})
    |> Repo.insert!
  end

  def unfollow(%User{id: follower_id} = _follower, %User{id: followee_id} = _followee) do
    Repo.get_by(Follow, %{follower_id: follower_id, followee_id: followee_id})
    |> Repo.delete!
  end
end
