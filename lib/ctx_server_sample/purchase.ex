defmodule CtxServerSample.Purchase do
  use Ecto.Schema

  schema "tests" do
    # field :id, :integer
    field :name, :string
    # field :purchase_id, :integer,
    # field :user_id, :string,
    # field :item_id, :integer
    # field :created_at,
  end

  # def init do
  #   :ets.new(@tab, [:named_table, :public])
  # end

  # def new(user_id, item_ids) do
  #   {1, user_id, item_ids, now()}
  # end

  # defp now do
  #   :os.timestamp |> :calendar.now_to_datetime
  # end
  
end
