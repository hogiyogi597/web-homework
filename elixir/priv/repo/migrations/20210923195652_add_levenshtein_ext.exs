defmodule Homework.Repo.Migrations.AddLevenshteinExt do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION fuzzystrmatch SCHEMA public;"
  end
end
