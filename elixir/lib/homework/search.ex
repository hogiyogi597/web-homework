defmodule Homework.Search do
  @moduledoc """
  The Search context.
  """
  import Ecto.Query, warn: false

  defmodule SearchTerm do
    @enforce_keys [:column, :search_phrase]
    defstruct [:column, :search_phrase]
  end

  def fuzzy_search(%{search: search}, base_query) do
    %{
      where_queries: where_queries,
      order_by_queries: order_by_queries
    } = Enum.map(search, fn {k, v} -> %SearchTerm{column: k, search_phrase: v} end)
      |> Enum.map(&fuzzy_search/1)
      |> Enum.reduce(%{}, fn (nested_map, acc) ->
        Map.merge(acc, nested_map, fn _, m1, m2 -> m1 ++ m2 end)
      end)

    query_with_where = Enum.reduce(where_queries, base_query, fn fragment, query ->
      from q in query, where: ^fragment
    end)

    Enum.reduce(order_by_queries, query_with_where, fn fragment, query ->
      from q in query, order_by: ^fragment
    end)
  end

  def fuzzy_search(_args, base_query) do
    base_query
  end

  def fuzzy_search(%SearchTerm{column: column, search_phrase: search_phrase}) do
    %{
      where_queries: [
        dynamic([u], fragment("SIMILARITY(?, ?) > 0",  field(u, ^column), ^search_phrase))
      ],
      order_by_queries: [
        dynamic([u], fragment("LEVENSHTEIN(?, ?)", field(u, ^column), ^search_phrase))
      ]
    }
  end
end
