defmodule Schema.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "item" do
    field(:code, :integer)
    field(:name, :string)
    field(:description, :string)
    field(:tradeable, :boolean, default: false)
    field(:image, :string)
    field(:price, :integer)
  end

  def changeset(item, params \\ %{}) do
    item
    |> cast(params, [:name, :code, :description, :tradeable, :image, :price])
    |> validate_required([:name, :item_code])
    |> unique_constraint(:item_code, name: :item_code_index)
    |> unique_constraint(:name, name: :item_name_index)
  end
end
