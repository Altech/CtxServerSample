defmodule CtxServerSample.Router do
  use Plug.Router

  plug Plug.Parsers, parsers: [:urlencoded]
  plug Plug.Session, store: :ets, key: "_ctx_sever", table: :session

  # plug Plug.Logger
  plug :match
  plug :dispatch

  def init(options) do
    :ets.new(:session, [:named_table, :public])
  end

  get "/pry" do
    require IEx
    IEx.pry
    send_resp(conn, 200, "IEx.pry")
  end

  get "test_server" do
    reply = CtxServer.call(TestServer, fetch_query_params(conn).params)
    send_resp(conn, 200 , "Success to call TestServer\n\n#{reply}")
  end

  get "test_server_post" do # This should be `post "test_server"`
    CtxServer.cast(TestServer, fetch_query_params(conn).params)
    send_resp(conn, 200, "Success to cast TestServer")
  end

  get "/" do
    conn = fetch_session(conn)
    reply = CtxServer.call(TestServer, {:get, :root, fetch_query_params(conn).params, %{user_id: get_session(conn, :user_id)}})
    send_resp(conn, 200, reply)
  end

  get "/login" do
    IO.puts "get-login"
    reply = CtxServer.call(TestServer, {:get, :login, fetch_query_params(conn).params})
    send_resp(conn, 200, reply)
  end

  post "/login" do
    {html, user_id} = CtxServer.call(TestServer, {:post, :login, fetch_query_params(conn).params})
    conn = fetch_session(conn)
    conn = put_session(conn, :user_id, user_id)
    send_resp(conn, 200, html)
  end

  get "/logout" do
    conn = fetch_session(conn)
    conn = delete_session(conn, :user_id)
    send_resp(conn, 200, "Success to logout")
  end
  
  get "/items" do
    reply = CtxServer.call(TestServer, {:get, :items})
    send_resp(conn, 200, reply)
  end

  post "/purchase" do
    # item_ids
    send_resp(conn, 200, "")
  end


  match _ do
    IO.inspect(conn.params)
    send_resp(conn, 404, "oops")
  end

end
