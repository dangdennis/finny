defmodule ElixirBackend.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\""

    create table(:users) do
      add :email, :string
      add :password_hash, :string
      add :apple_sub, :string

      timestamps()
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:apple_sub])
  end
end
