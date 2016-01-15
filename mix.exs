defmodule CtxServerSample.Mixfile do
  use Mix.Project

  def project do
    [app: :ctx_server_sample,
     version: "0.0.1",
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    ctx_server = if Mix.env == :dev do
      System.get_env("HOME") <> "/CtxServer"
    else
      "git@github.com:psg-titech/CtxServer.git"
    end
    [{:ctx_server, git: ctx_server}]
  end
end
