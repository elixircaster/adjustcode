defmodule Adjust.MixProject do
  use Mix.Project

  def project do
    [
      app: :adjust,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
	  
      applications: [:logger, :poolboy, :cowboy, :plug, :postgrex],
	  mod: {Adjust,[]}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
	     {:postgrex, "~> 0.13.5"},
	     {:poolboy, "~> 1.5"},
         {:cowboy, "~> 1.0.0"},
      {:plug, "~> 1.0"},
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
