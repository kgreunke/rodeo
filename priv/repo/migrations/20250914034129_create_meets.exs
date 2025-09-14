defmodule Rodeo.Repo.Migrations.CreateMeets do
  use Ecto.Migration

  def change do
    create table(:meets) do
      add :name, :string
      add :date, :naive_datetime
      add :location, :string
      add :org_id, references(:organizations, on_delete: :nothing)
      add :user_id, references(:users, type: :id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:meets, [:user_id])

    create index(:meets, [:org_id])
  end
end
