defmodule Homework.Repo.Migrations.AddSimilarityExt do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION pg_trgm;"
  end
end
