defmodule HomeworkWeb.Schemas.MerchantsSchema do
  @moduledoc """
  Defines the graphql schema for merchants.
  """
  use Absinthe.Schema.Notation

  alias HomeworkWeb.Resolvers.MerchantsResolver

  object :merchant do
    field(:id, non_null(:id))
    field(:name, :string)
    field(:description, :string)
    field(:inserted_at, :naive_datetime)
    field(:updated_at, :naive_datetime)
  end

  input_object :search_merchant do
    field(:name, :string)
  end

  object :merchants do
    field(:items, list_of(:merchant)) do
      arg(:pagination, :pagination)
      arg(:search, :search_merchant)
      resolve(&MerchantsResolver.merchants/3)
    end

    field(:total_items, :integer) do
      resolve(&MerchantsResolver.get_total/3)
    end
  end

  object :merchant_queries do
    @desc "Get a Merchant by its id"
    field(:merchant, :merchant) do
      arg(:id, non_null(:id))
      resolve(&MerchantsResolver.merchant/3)
    end

    @desc "Get all Merchants"
    field(:merchants, :merchants) do
      resolve(fn _, _ -> {:ok, %{}} end)
    end
  end

  object :merchant_mutations do
    @desc "Create a new merchant"
    field :create_merchant, :merchant do
      arg(:name, non_null(:string))
      arg(:description, non_null(:string))

      resolve(&MerchantsResolver.create_merchant/3)
    end

    @desc "Update a new merchant"
    field :update_merchant, :merchant do
      arg(:id, non_null(:id))
      arg(:name, non_null(:string))
      arg(:description, non_null(:string))

      resolve(&MerchantsResolver.update_merchant/3)
    end

    @desc "Delete an existing merchant"
    field :delete_merchant, :merchant do
      arg(:id, non_null(:id))

      resolve(&MerchantsResolver.delete_merchant/3)
    end
  end
end
