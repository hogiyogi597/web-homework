defmodule Homework.Pagination do
  @moduledoc """
  The Pagination context.
  """

  import Ecto.Query, warn: false
  alias Homework.Repo

  def handle_pagination(args, from_query) do
    {limit, skip} =
      case args do
        %{pagination: %{limit: limit, skip: skip}} ->
          {limit, skip}

        %{pagination: %{limit: limit}} ->
          {limit, nil}

        %{pagination: %{skip: skip}} ->
          {nil, skip}

        _ ->
          {nil, nil}
      end

    Repo.all(from(p in subquery(from_query), limit: ^limit, offset: ^skip, select: p))
  end

  def handle_total_items(from_query) do
    Repo.one(from(p in subquery(from_query), select: count(p)))
  end
end
