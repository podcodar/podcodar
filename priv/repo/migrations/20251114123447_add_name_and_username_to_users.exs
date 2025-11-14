defmodule Podcodar.Repo.Migrations.AddNameAndUsernameToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :name, :string
      add :username, :string
    end

    create unique_index(:users, [:username])
  end
end
