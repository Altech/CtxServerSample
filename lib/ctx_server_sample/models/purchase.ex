defmodule CtxServerSample.Models.Purchase do
  use Ecto.Schema

  alias __MODULE__
  alias CtxServerSample.Repo

  schema "purchases" do
    belongs_to :user, CtxServerSample.Models.User
    belongs_to :item, CtxServerSample.Models.Item
    timestamps
  end

  def create(user_id, item_id) do
    purchase = %Purchase{user_id: user_id, item_id: item_id}
    Repo.insert(purchase)
  end
end
