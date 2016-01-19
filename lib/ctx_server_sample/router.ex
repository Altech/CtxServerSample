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

  post "/login" do
    conn = fetch_session(conn)
    session_params = %{user_id: get_session(conn, :user_id)}
    reply = CtxServer.call(HTTPServer, {conn.method, conn.request_path, fetch_query_params(conn).params, session_params})

    # Extension [TODO] Manipulate session in HTTPServer
    screen_name = conn.params["screen_name"]
    user = CtxServerSample.User.find_by_screen_name(screen_name) 
    if user do
      conn = put_session(conn, :user_id, user.id)
    end

    send_resp(conn, 200, reply)
  end

  get "/logout" do
    conn = fetch_session(conn)
    conn = delete_session(conn, :user_id)
    send_resp(conn, 200, "Success to logout")
  end
  
  get "/pry" do # For debug
    require IEx
    IEx.pry
    send_resp(conn, 200, "IEx.pry")
  end

  match _ do
    conn = fetch_session(conn)
    session_params = %{user_id: get_session(conn, :user_id)}
    reply = CtxServer.call(HTTPServer, {conn.method, conn.request_path, fetch_query_params(conn).params, session_params})
    send_resp(conn, 200, reply)
  end

end
