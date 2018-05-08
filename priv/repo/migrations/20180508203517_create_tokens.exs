defmodule Fontina.Repo.Migrations.CreateTokens do
  use Ecto.Migration

  def change do
    create table(:tokens) do
      add :user_id, references(:users)
      add :is_browser, :boolean

      timestamps()
    end

    create index(:tokens, [:user_id])
  end
end
