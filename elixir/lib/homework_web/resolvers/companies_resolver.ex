defmodule HomeworkWeb.Resolvers.CompaniesResolver do
  alias Homework.Companies
  alias Homework.Transactions

  @doc """
  Get a list of companies
  """
  def companies(_root, args, _info) do
    {:ok, Companies.list_companies(args)}
  end

  @doc """
  Get the total count of companies
  """
  def get_total(_root, _args, _info) do
    {:ok, Companies.get_total()}
  end

  @doc """
  Get a company by its id
  """
  def company(_root, %{id: id}, _info) do
    {:ok, Companies.get_company(id)}
  end

  @doc """
  Create a new company
  """
  def create_company(_root, args, _info) do
    case Companies.create_company(args) do
      {:ok, company} ->
        {:ok, company}

      error ->
        {:error, "could not create company: #{inspect(error)}"}
    end
  end

  @doc """
  Updates a company for an id with args specified.
  """
  def update_company(_root, %{id: id} = args, _info) do
    company = Companies.get_company!(id)

    case Companies.update_company(company, args) do
      {:ok, company} ->
        {:ok, company}

      error ->
        {:error, "could not update company: #{inspect(error)}"}
    end
  end

  @doc """
  Deletes a company for an id
  """
  def delete_company(_root, %{id: id}, _info) do
    company = Companies.get_company!(id)

    case Companies.delete_company(company) do
      {:ok, company} ->
        {:ok, company}

      error ->
        {:error, "could not update company: #{inspect(error)}"}
    end
  end

  @doc """
  Calculates the available credit of a company by summing the transaction amounts
  and subtracting that from the company's credit_line
  """
  def calculate_available_credit(%{id: company_id, credit_line: credit_line}, _args, _info) do
    total_transaction_amount = Transactions.accumulate_company_transactions(company_id)
    {:ok, Companies.calculate_available_credit(credit_line, total_transaction_amount)}
  end
end
