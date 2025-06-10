defmodule MyApp.Repo.Migrations.CreateItem do
  use Ecto.Migration

  def change do
    create table(:item) do
      add(:code, :integer)
      add(:name, :string)
      add(:description, :string)
      add(:tradeable, :boolean, default: false)
      add(:image, :string)
      add(:price, :integer)
    end

    create(unique_index(:item, [:code], name: :item_code_index))
    create(unique_index(:item, [:name], name: :item_name_index))
  end
end
