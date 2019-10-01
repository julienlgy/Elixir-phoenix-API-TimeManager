defmodule TimeManager.Repo.Migrations.AddTeams do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:teams) do
      add :name, :string, null: false
      add :color, :string, null: false

      timestamps()
    end
  end
end
