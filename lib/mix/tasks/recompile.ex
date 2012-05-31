defmodule Mix.Tasks.Recompile do
  use Mix.Task
  @shortdoc "Compile files using rebar."

  def run(_args) do
    Mix.Rebar.run(['compile'])
  end
end
