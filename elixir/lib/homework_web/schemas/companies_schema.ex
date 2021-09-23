defmodule HomeworkWeb.Schemas.CompaniesSchema do
  @moduledoc """
  Defines the graphql schema for companies.
  """
  use Absinthe.Schema.Notation

  alias HomeworkWeb.Resolvers.CompaniesResolver
  alias HomeworkWeb.Resolvers.TransactionsResolver

  object :company do
    field(:id, non_null(:id))
    field(:name, :string)
    field(:credit_line, :dollar)

    field(:available_credit, :dollar) do
      resolve(&TransactionsResolver.calculate_available_credit/3)
    end

    field(:inserted_at, :naive_datetime)
    field(:updated_at, :naive_datetime)
  end

  object :companies do
    field(:items, list_of(:company)) do
      arg(:pagination, :pagination)
      resolve(&CompaniesResolver.companies/3)
    end

    field(:total_items, :integer) do
      resolve(&CompaniesResolver.get_total/3)
    end
  end

  object :company_queries do
    @desc "Get a Company by its id"
    field(:company, :company) do
      arg(:id, non_null(:id))
      resolve(&CompaniesResolver.company/3)
    end

    @desc "Get all Companies"
    field(:companies, :companies) do
      resolve(fn _, _ -> {:ok, %{}} end)
    end
  end

  object :company_mutations do
    @desc "Create a new company"
    field :create_company, :company do
      arg(:name, non_null(:string))
      arg(:credit_line, non_null(:dollar))

      resolve(&CompaniesResolver.create_company/3)
    end

    @desc "Update a new company"
    field :update_company, :company do
      arg(:id, non_null(:id))
      arg(:name, non_null(:string))
      arg(:credit_line, non_null(:dollar))

      resolve(&CompaniesResolver.update_company/3)
    end

    @desc "Delete an existing company"
    field :delete_company, :company do
      arg(:id, non_null(:id))

      resolve(&CompaniesResolver.delete_company/3)
    end
  end
end
