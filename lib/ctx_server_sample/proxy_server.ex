defmodule CtxServerSample.ProxyServer do
  def start_link() do
    {:ok, _} = Plug.Adapters.Cowboy.http(CtxServerSample.ProxyServer.Router, [])
  end

  defmodule Router do
    use Plug.Router

    plug Plug.Parsers, parsers: [:urlencoded]
    plug Plug.Session, store: :ets, key: "_ctx_sever", table: :session

    plug :match
    plug :dispatch

    def init(options) do
      :ets.new(:session, [:named_table, :public])
    end

    match _ do
      conn = fetch_session(conn)
      CtxServer.switch_context(:current_user, CtxServerSample.Models.User.find_by_id(get_session(conn, :user_id)))
      {html, is} = CtxServer.call(HTTPServer, {conn.method, conn.request_path, fetch_query_params(conn).params})
      conn = Enum.reduce(is, conn, fn ({name, args}, acc) ->
        apply(Plug.Conn, name, [conn|args])
      end)
      send_resp(conn, 200, html)
    end
  end
end
