defmodule Podcodar.Repo.Migrations.AddNameAndUsernameToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :name, :string, null: false, default: ""
      add :username, :string, null: false, default: ""
    end

    # Update usernames to use email where username is empty
    execute("UPDATE users SET username = email WHERE username = ''", "")

    create unique_index(:users, [:username])
  end
end
