defmodule Fontina.Repo.Migrations.CreateTokens do
  use Ecto.Migration

  def change do
    create table(:tokens) do
      add :user_id, references(:users)
      add :is_browser, :boolean
      add :value, :string

      timestamps()
    end

    create index(:tokens, [:user_id])
    create unique_index(:tokens, [:value])
  end
end
