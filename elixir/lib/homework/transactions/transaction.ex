defmodule Homework.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset
  alias Homework.Merchants.Merchant
  alias Homework.Companies.Company
  alias Homework.Users.User

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "transactions" do
    field(:amount, :integer)
    field(:credit, :boolean, default: false)
    field(:debit, :boolean, default: false)
    field(:description, :string)

    belongs_to(:merchant, Merchant, type: :binary_id, foreign_key: :merchant_id)
    belongs_to(:user, User, type: :binary_id, foreign_key: :user_id)
    belongs_to(:company, Company, type: :binary_id, foreign_key: :company_id)

    timestamps()
  end

  def convert_amount(transaction) when is_float(transaction.amount) do
    integer_amount =
      Decimal.from_float(transaction.amount * 100) |> Decimal.round() |> Decimal.to_integer()

    %{transaction | amount: integer_amount}
  end

  def convert_amount(transaction) when is_integer(transaction.amount) do
    dollar_amount = transaction.amount / 100.0

    %{transaction | amount: dollar_amount}
  end

  def convert_amount(transaction) when is_nil(transaction.amount) do
    transaction
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:user_id, :company_id, :amount, :credit, :debit, :description, :merchant_id])
    |> validate_required([
      :user_id,
      :company_id,
      :amount,
      :credit,
      :debit,
      :description,
      :merchant_id
    ])
  end
end
