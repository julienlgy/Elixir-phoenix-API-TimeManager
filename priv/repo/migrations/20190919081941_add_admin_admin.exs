defmodule TimeManager.Repo.Migrations.AddAdminAdmin do
  use Ecto.Migration
  
  alias TimeManager.Auth
  alias TimeManager.Auth.User
  alias TimeManager.Auth.Role

  def change do
    role_params = %{name: "admin", permission: "99"}
    with {:ok, %User{} = user} <- Auth.create_role(role_params) do
      IO.puts("role admin created")
    end
    user_params = %{ username: "admin", password: "admin", email: "localhost@localhost.fr", roleid: 4 }
    with {:ok, %User{} = user} <- Auth.create_user(user_params) do
      IO.puts("user created")
    end
  end
end
