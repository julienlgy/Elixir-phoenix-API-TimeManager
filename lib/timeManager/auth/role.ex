defmodule TimeManager.Auth.Role do
  use Ecto.Schema
  import Ecto.Changeset

  schema "roles" do
    field :name, :string
    field :permission, :integer
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name, :permission])
    |> validate_required([:name, :permission])
  end
end