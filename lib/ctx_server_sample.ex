defmodule CtxServerSample do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(CtxServerSample.Repo, []),
      worker(CtxServerSample.Plugstarter, []),
      worker(CtxServerSample.HTTPServer, [HTTPServer]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CtxServerSample.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
