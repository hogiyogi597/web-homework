# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Homework.Repo.insert!(%Homework.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Homework.Companies.Company
alias Homework.Merchants.Merchant
alias Homework.Transactions.Transaction
alias Homework.Users.User

defmodule Seed do
  @max_companies 10
  @max_users_per_company 2
  @max_transactions_per_user 5

  @user_first_names [
    "Casey",
    "Lucrecia",
    "Anibal",
    "Debbi",
    "Carin",
    "Rolland",
    "Annalisa",
    "Jc",
    "Raye",
    "Ines"
  ]

  @user_last_names [
    "Kayce",
    "Willodean",
    "Otelia",
    "Shaunda",
    "Pauletta",
    "Charlotte",
    "Julienne",
    "Nathalie",
    "Codi",
    "Myra"
  ]

  def generate_random_dob do
    year = Enum.random(1995..2020)
    month = Enum.random(1..12)
    day = Enum.random(1..28)
    "#{year}-#{month}-#{day}"
  end

  def generate_users_for_company(company_id) do
    users_per_company = Enum.random(1..@max_users_per_company)

    for u <- 1..users_per_company do
      Homework.Repo.insert!(%User{
        first_name: Enum.random(@user_first_names),
        last_name: Enum.random(@user_last_names),
        dob: generate_random_dob(),
        company_id: company_id
      })
    end
  end

  def generate_transactions_for_user(
        %User{} = user,
        %Merchant{} = merchant,
        number_of_transactions
      ) do
    for n <- 1..number_of_transactions do
      is_credit = Enum.random(1..100) > 50

      Homework.Repo.insert!(%Transaction{
        amount: Enum.random(100..100_000),
        credit: is_credit,
        debit: !is_credit,
        description: "Transaction #{n}",
        merchant_id: merchant.id,
        user_id: user.id,
        company_id: user.company_id
      })
    end
  end

  def run do
    for n <- 1..@max_companies do
      %{id: company_id} =
        Homework.Repo.insert!(%Company{name: "Company #{n}", credit_line: n * 100})

      merchant =
        Homework.Repo.insert!(%Merchant{name: "Merchant #{n}", description: "Merchant #{n}"})

      for user <- generate_users_for_company(company_id),
          do:
            generate_transactions_for_user(
              user,
              merchant,
              Enum.random(1..@max_transactions_per_user)
            )
    end
  end
end

Seed.run()
