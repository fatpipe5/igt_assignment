defmodule ClothingDashboard.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    timestamps()
  end

  def registration_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_length(:password, min: 6)
    |> unique_constraint(:email)
    |> hash_password()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 6)
    |> hash_password()
  end

  defp hash_password(changeset) do
    if changeset.valid? do
      put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(get_change(changeset, :password)))
    else
      changeset
    end
  end

end
