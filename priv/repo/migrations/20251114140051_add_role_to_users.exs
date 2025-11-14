defmodule Podcodar.Repo.Migrations.AddRoleToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :role, :string, null: false, default: "member"
    end

    create index(:users, [:role])
  end
end
