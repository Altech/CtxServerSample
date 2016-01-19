defmodule CtxServerSample.Models.Item do
  use Ecto.Schema

  alias __MODULE__
  alias CtxServerSample.Repo

  schema "items" do
    field :title, :string
    field :description, :string
    field :price, :integer
  end

  def first(n) do
    import Ecto.Query, only: [from: 2]
    Repo.all(from i in Item, limit: ^n)
  end
end
