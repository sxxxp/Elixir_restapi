defmodule MyApp.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:name, :string)
      add(:image, :string)
      add(:email, :string)
      add(:password, :string, virtual: true)
      add(:password_hash, :string)

      timestamps()
    end

    create(unique_index(:users, [:email], name: :users_email_index))
    create(unique_index(:users, [:name], name: :users_name_index))
  end
end
