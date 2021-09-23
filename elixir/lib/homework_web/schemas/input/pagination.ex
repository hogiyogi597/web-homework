defmodule HomeworkWeb.Input.Pagination do
  use Absinthe.Schema.Notation

  input_object :pagination do
    field(:limit, :integer)
    field(:skip, :integer)
  end
end
