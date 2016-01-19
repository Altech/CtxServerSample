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
  
  get "/pry" do # For debug
    require IEx
    IEx.pry
    send_resp(conn, 200, "IEx.pry")
  end

  match _ do
    conn = fetch_session(conn)
    session_params = %{user_id: get_session(conn, :user_id)}
    {html, is} = CtxServer.call(HTTPServer, {conn.method, conn.request_path, fetch_query_params(conn).params, session_params})
    for {name, args} <- is do
      apply(Plug.Conn, name, [conn|args])
    end
    send_resp(conn, 200, html)
  end

end
