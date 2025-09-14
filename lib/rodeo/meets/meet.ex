defmodule Rodeo.Meets.Meet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "meets" do
    field :name, :string
    field :date, :naive_datetime
    field :location, :string
    field :org_id, :id
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(meet, attrs, user_scope) do
    meet
    |> cast(attrs, [:name, :date, :location])
    |> validate_required([:name, :date, :location])
    |> put_change(:user_id, user_scope.user.id)
  end
end
