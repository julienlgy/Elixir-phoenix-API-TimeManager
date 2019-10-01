defmodule TimeManager.Auth.Team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :color, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name, :color])
    |> validate_required([:name, :color])
  end
end
