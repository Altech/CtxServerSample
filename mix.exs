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

  def application do
    [
      applications: [:logger],
      mod: {CtxServerSample, []}
    ]
  end

  defp deps do
    ctx_server = if Mix.env == :dev do
      System.get_env("HOME") <> "/CtxServer"
    else
      "git@github.com:psg-titech/CtxServer.git"
    end
    [
      {:ctx_server, git: ctx_server},
      {:cowboy, "~> 1.0.0"},
      {:plug, "~> 1.1.0"},
      {:eml, git: "https://github.com/zambal/eml.git"},
    ]
  end
end
