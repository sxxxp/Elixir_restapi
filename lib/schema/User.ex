defmodule Schema.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:name, :string)
    field(:email, :string)
    field(:password, :string, virtual: true)
    field(:password_hash, :string)

    timestamps()
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:name, :email, :password])
    |> validate_required([:name, :email, :password])
    |> validate_format(:email, ~r/@/)
    |> encrypt_password()
    |> unique_constraint(:email, name: :users_email_index)
    |> unique_constraint(:name, name: :users_name_index)
  end

  defp encrypt_password(changeset) do
    password = get_change(changeset, :password)

    if password do
      put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(password))
    else
      changeset
    end
  end

  def verify_password(password, hash) do
    Pbkdf2.verify_pass(password, hash)
  end
end
