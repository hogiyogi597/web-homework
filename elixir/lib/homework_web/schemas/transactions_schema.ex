defmodule HomeworkWeb.Schemas.TransactionsSchema do
  @moduledoc """
  Defines the graphql schema for transactions.
  """
  use Absinthe.Schema.Notation

  alias HomeworkWeb.Resolvers.TransactionsResolver

  object :transaction do
    field(:id, non_null(:id))
    field(:user_id, :id)
    field(:amount, :dollar)
    field(:credit, :boolean)
    field(:debit, :boolean)
    field(:description, :string)
    field(:merchant_id, :id)
    field(:company_id, :id)
    field(:inserted_at, :naive_datetime)
    field(:updated_at, :naive_datetime)

    field(:user, :user) do
      resolve(&TransactionsResolver.user/3)
    end

    field(:merchant, :merchant) do
      resolve(&TransactionsResolver.merchant/3)
    end

    field(:company, :company) do
      resolve(&TransactionsResolver.company/3)
    end
  end

  object :transactions do
    field(:items, list_of(:transaction)) do
      arg(:pagination, :pagination)
      resolve(&TransactionsResolver.transactions/3)
    end

    field(:total_items, :integer) do
      resolve(&TransactionsResolver.get_total/3)
    end
  end

  object :transaction_queries do
    @desc "Get a Transaction by its id"
    field(:transaction, :transaction) do
      arg(:id, non_null(:id))
      resolve(&TransactionsResolver.transaction/3)
    end

    @desc "Get all Transactions"
    field(:transactions, :transactions) do
      resolve(fn _, _ -> {:ok, %{}} end)
    end
  end

  object :transaction_mutations do
    @desc "Create a new transaction"
    field :create_transaction, :transaction do
      arg(:user_id, non_null(:id))
      arg(:merchant_id, non_null(:id))
      arg(:company_id, non_null(:id))
      @desc "amount is in dollars"
      arg(:amount, non_null(:dollar))
      arg(:credit, non_null(:boolean))
      arg(:debit, non_null(:boolean))
      arg(:description, non_null(:string))

      resolve(&TransactionsResolver.create_transaction/3)
    end

    @desc "Update a new transaction"
    field :update_transaction, :transaction do
      arg(:id, non_null(:id))
      arg(:user_id, non_null(:id))
      arg(:merchant_id, non_null(:id))
      arg(:company_id, non_null(:id))
      @desc "amount is in dollars"
      arg(:amount, non_null(:dollar))
      arg(:credit, non_null(:boolean))
      arg(:debit, non_null(:boolean))
      arg(:description, non_null(:string))

      resolve(&TransactionsResolver.update_transaction/3)
    end

    @desc "Delete an existing transaction"
    field :delete_transaction, :transaction do
      arg(:id, non_null(:id))

      resolve(&TransactionsResolver.delete_transaction/3)
    end
  end
end
