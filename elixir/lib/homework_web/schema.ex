defmodule HomeworkWeb.Schema do
  @moduledoc """
  Defines the graphql schema for this project.
  """
  use Absinthe.Schema

  alias HomeworkWeb.Resolvers.MerchantsResolver
  alias HomeworkWeb.Resolvers.CompaniesResolver
  alias HomeworkWeb.Resolvers.TransactionsResolver
  alias HomeworkWeb.Resolvers.UsersResolver
  import_types(HomeworkWeb.Schemas.Types)

  query do
    @desc "Get all Transactions"
    field(:transactions, :transactions) do
      resolve(fn _, _ -> {:ok, %{}} end)
    end

    @desc "Get all Users"
    field(:users, :users) do
      resolve(fn _, _ -> {:ok, %{}} end)
    end

    @desc "Get all Merchants"
    field(:merchants, :merchants) do
      resolve(fn _, _ -> {:ok, %{}} end)
    end

    @desc "Get all Companies"
    field(:companies, :companies) do
      resolve(fn _, _ -> {:ok, %{}} end)
    end
  end

  mutation do
    import_fields(:company_mutations)
    import_fields(:transaction_mutations)
    import_fields(:user_mutations)
    import_fields(:merchant_mutations)
  end
end
