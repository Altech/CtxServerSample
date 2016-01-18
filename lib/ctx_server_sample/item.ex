defmodule CtxServerSample.Item do
  @tab :items

  def init do
    :ets.new(@tab, [:named_table, :public])
    items = [
      {1, "iPad 16GB", 400},
      {2, "iPhone 32GB", 800},
      {3, "Nexsus", 300},
      {4, "Garaxy", 100},
    ]
    for item <- items do
      :ets.insert(:items, items)
    end
  end

  def all do
    :ets.match(@tab, {:_, :"$2", :"$3"})
  end
end
