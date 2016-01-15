# CtxServerSample

- https://github.com/psg-titech/CtxServer/issues/6#issuecomment-160952368
- https://github.com/psg-titech/CtxServer/issues/8

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add ctx_server_sample to your list of dependencies in `mix.exs`:

        def deps do
          [{:ctx_server_sample, "~> 0.0.1"}]
        end

  2. Ensure ctx_server_sample is started before your application:

        def application do
          [applications: [:ctx_server_sample]]
        end
