defmodule Mix.Tasks.Favicon do
  @moduledoc "The favicon mix task: `mix help favicon`"
  use Mix.Task

  @shortdoc "Generates a favicon from logo.svg"
  def run(_command_line_args) do
    # calling `convert` in shellscript
    System.cmd("sh", ["-c", "magick priv/static/images/logo.svg -resize 64x64 priv/static/favicon.ico"])
  end
  
end
