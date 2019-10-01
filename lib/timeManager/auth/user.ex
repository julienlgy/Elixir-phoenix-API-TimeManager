defmodule TimeManager.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :password, :string
    field :username, :string
    field :roleid, :id, default: 1

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :email, :roleid])
    |> validate_required([:username, :password, :email])
  end
end
