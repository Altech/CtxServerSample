defmodule CtxServerSample do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(CtxServerSample.Repo, []),
      worker(CtxServerSample.ProxyServer, []), 
      worker(CtxServerSample.HTTPServer, [HTTPServer]),
    ]

    opts = [strategy: :one_for_one, name: CtxServerSample.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
