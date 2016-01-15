defmodule CtxServerSample.Router do
  use Plug.Router
  require Logger

  # plug Plug.Logger
  plug :match
  plug :dispatch

  def init(options) do
    # initialize your options here

    options
  end


  get "/" do
    # Get the parameters
    conn = fetch_query_params(conn)

    send_resp(conn, 200, "received #{inspect(conn.params)}")
  end

  get "test_server" do
    reply = CtxServer.call(TestServer, fetch_query_params(conn).params)
    send_resp(conn, 200 , "Success to call TestServer\n\n#{reply}")
  end

  get "test_server_post" do # This should be `post "test_server"`
    CtxServer.cast(TestServer, fetch_query_params(conn).params)
    send_resp(conn, 200, "Success to cast TestServer")
  end

  match _ do
    IO.inspect(conn.params)
    send_resp(conn, 404, "oops")
  end

end
