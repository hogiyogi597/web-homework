defmodule HomeworkWeb.Resolvers.UsersResolver do
  alias Homework.Users
  alias Homework.Companies

  @doc """
  Get a list of users
  """
  def users(_root, args, _info) do
    {:ok, Users.list_users(args)}
  end

  def get_total(_root, _args, _info) do
    {:ok, Users.get_total()}
  end

  @doc """
  Get a user by its id
  """
  def user(_root, %{id: id}, _info) do
    {:ok, Users.get_user(id)}
  end

  @doc """
  Get the company associated with a user
  """
  def company(_root, _args, %{source: %{company_id: company_id}}) do
    {:ok, Companies.get_company!(company_id)}
  end

  @doc """
  Creates a user
  """
  def create_user(_root, args, _info) do
    case Users.create_user(args) do
      {:ok, user} ->
        {:ok, user}

      error ->
        {:error, "could not create user: #{inspect(error)}"}
    end
  end

  @doc """
  Updates a user for an id with args specified.
  """
  def update_user(_root, %{id: id} = args, _info) do
    user = Users.get_user!(id)

    case Users.update_user(user, args) do
      {:ok, user} ->
        {:ok, user}

      error ->
        {:error, "could not update user: #{inspect(error)}"}
    end
  end

  @doc """
  Deletes a user for an id
  """
  def delete_user(_root, %{id: id}, _info) do
    user = Users.get_user!(id)

    case Users.delete_user(user) do
      {:ok, user} ->
        {:ok, user}

      error ->
        {:error, "could not update user: #{inspect(error)}"}
    end
  end
end
