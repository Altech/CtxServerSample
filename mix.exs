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
      applications: [:logger, :ecto, :postgrex],
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
      {:ctx_server, git: ctx_server}, # Context-Aware GenServer
      {:cowboy, "~> 1.0.0"}, # HTTP Server
      {:plug, "~> 1.1.0"}, # Functional HTTP Processing
      {:eml, git: "https://github.com/zambal/eml.git"}, # HTML Template Engine
      {:postgrex, ">= 0.0.0"},
      {:ecto, "~> 1.1"}, # Database wrapper
    ]
  end
end
