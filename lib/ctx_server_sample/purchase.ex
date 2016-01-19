defmodule CtxServerSample.Purchase do
  @tab :purchase

  # # Schema
  # {purchase_id: Number, user_id: ByteString, item_ids: List<Number>, created_at: Time}

  def init do
    :ets.new(@tab, [:named_table, :public])
  end

  def new(user_id, item_ids) do
    {index, user_id, item_ids, now()}
  end

  defp now do
    :os.timestamp |> :calendar.now_to_datetime
  end
  
end
