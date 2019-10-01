defmodule TimeManager.Auth.Clock do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clocks" do
    field :status, :boolean, default: false
    field :time, :utc_datetime
    field :user, :id
    #belongs_to :user, TimeManager.Auth.User

    timestamps()
  end

  @doc false
  def changeset(clock, attrs) do
    clock
    |> cast(attrs, [:time, :status, :user])
    |> validate_required([:time, :status, :user])
  end
end
