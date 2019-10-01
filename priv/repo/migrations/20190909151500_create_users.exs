defmodule TimeManager.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:users) do
      add :username, :string, null: false
      add :email, :string, null: false
      add :password, :string
      add :roleid, references(:roles, on_delete: :delete_all), null: false
      
      timestamps()
    end
    create constraint(
      "users", 
      "is_email_valid",
      check: "email ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$'"
    )
    # Not working...  (timestamps) #execute "INSERT INTO users (username, email, password, roleid) VALUES ('admin', 'localhost@localhost.com', MD5(concat('admin', '1x2x$$££$$££3456789hashtimemanager_unkr4k4bl3'),99)"
  end
end
