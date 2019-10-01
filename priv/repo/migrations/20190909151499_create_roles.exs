defmodule TimeManager.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :name, :string, null: false
      add :permission, :integer, null: false
    end
    execute "INSERT INTO roles (name, permission) VALUES ('employee', 1)"
    execute "INSERT INTO roles (name, permission) VALUES ('manager', 2)"
    execute "INSERT INTO roles (name, permission) VALUES ('general-manager', 3)"
  end
end
