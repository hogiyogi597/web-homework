defmodule HomeworkWeb.Scalars.Dollar do
  use Absinthe.Schema.Notation

  # Defining a custom scalar seems more appropriate for the dollar type instead of needing to remember to convert it everywhere like I had it before.
  # https://hexdocs.pm/absinthe/custom-scalars.html
  scalar :dollar, name: "Dollar" do
    serialize(&serialize_cents_as_dollar/1)
    parse(&parse_dollar/1)
  end

  defp parse_dollar(%Absinthe.Blueprint.Input.Float{value: dollar}) do
    try do
      {:ok, Decimal.from_float(dollar * 100) |> Decimal.round() |> Decimal.to_integer()}
    rescue
      _ -> :error
    end
  end

  defp parse_dollar(%Absinthe.Blueprint.Input.Null{}) do
    {:ok, nil}
  end

  defp parse_datetime(_) do
    :error
  end

  defp serialize_cents_as_dollar(cents) do
    cents / 100.0
  end
end
