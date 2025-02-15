defmodule HomeworkWeb.Schemas.UsersSchema do
  @moduledoc """
  Defines the graphql schema for user.
  """
  use Absinthe.Schema.Notation

  alias HomeworkWeb.Resolvers.UsersResolver

  object :user do
    field(:id, non_null(:id))
    field(:dob, :string)
    field(:first_name, :string)
    field(:last_name, :string)
    field(:inserted_at, :naive_datetime)
    field(:updated_at, :naive_datetime)

    field(:user, :user) do
      resolve(&UsersResolver.user/3)
    end
  end

  input_object :search_user do
    field(:first_name, :string)
    field(:last_name, :string)
  end

  object :users do
    field(:items, list_of(:user)) do
      arg(:pagination, :pagination)
      arg(:search, :search_user)
      resolve(&UsersResolver.users/3)
    end

    field(:total_items, :integer) do
      resolve(&UsersResolver.get_total/3)
    end
  end

  object :user_queries do
    @desc "Get a User by its id"
    field(:user, :user) do
      arg(:id, non_null(:id))
      resolve(&UsersResolver.user/3)
    end

    @desc "Get all Users"
    field(:users, :users) do
      resolve(fn _, _ -> {:ok, %{}} end)
    end
  end


  object :user_mutations do
    @desc "Create a new user"
    field :create_user, :user do
      arg(:dob, non_null(:string))
      arg(:first_name, non_null(:string))
      arg(:last_name, non_null(:string))

      resolve(&UsersResolver.create_user/3)
    end

    @desc "Update a new user"
    field :update_user, :user do
      arg(:id, non_null(:id))
      arg(:dob, non_null(:string))
      arg(:first_name, non_null(:string))
      arg(:last_name, non_null(:string))

      resolve(&UsersResolver.update_user/3)
    end

    @desc "Delete an existing user"
    field :delete_user, :user do
      arg(:id, non_null(:id))

      resolve(&UsersResolver.delete_user/3)
    end
  end
end
