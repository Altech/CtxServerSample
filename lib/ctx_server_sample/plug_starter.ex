defmodule CtxServerSample.Plugstarter do

  def start_link() do
    {:ok, _} = Plug.Adapters.Cowboy.http CtxServerSample.Router, []
  end

end