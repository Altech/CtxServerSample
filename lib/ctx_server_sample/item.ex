defmodule CtxServerSample.Item do
  use Ecto.Schema

  schema "items" do
    field :title, :string
    field :description, :string
    field :price, :integer
  end
end
