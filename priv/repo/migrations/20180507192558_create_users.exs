defmodule Fontina.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :nickname, :string
      add :email, :string
      add :bio, :string
      add :following, {:array, :string}
      add :followers, {:array, :string}
      add :pass_hash, :string

      timestamps()
    end

  end
end
