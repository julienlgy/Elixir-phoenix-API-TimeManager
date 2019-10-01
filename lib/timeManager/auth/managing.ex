defmodule TimeManager.Auth.Managing do
  use Ecto.Schema
  import Ecto.Changeset

  schema "managing" do
    field :isManager, :boolean, default: false
    field :teamId, :id
    field :employeeId, :id

    timestamps()
  end

  @doc false
  def changeset(managing, attrs) do
    managing
    |> cast(attrs, [:teamId, :employeeId, :isManager])
    |> validate_required([:teamId, :employeeId, :isManager])
  end
end
