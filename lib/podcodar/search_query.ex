defmodule Podcodar.SearchQuery do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :query, :string
  end

  @doc """
  Basic validation for the home page search field.
  """
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, [:query])
    |> validate_required([:query])
    |> validate_length(:query, min: 2)
  end
end
