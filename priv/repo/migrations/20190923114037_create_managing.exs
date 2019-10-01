defmodule TimeManager.Repo.Migrations.CreateManaging do
  use Ecto.Migration

  def change do
    create table(:managing) do
      add :isManager, :boolean, default: false, null: false
      add :teamId, references(:teams, on_delete: :delete_all)
      add :employeeId, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:managing, [:teamId])
    create index(:managing, [:employeeId])
  end
end
