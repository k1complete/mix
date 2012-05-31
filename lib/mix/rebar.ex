defmodule Mix.Rebar do
  def start do
    loaded = :application.loaded_applications
    unless List.keyfind(loaded, :rebar, 1), do: :rebar.start()
  end

  def run(args) do
    start

    try do
      :rebar.run(args, rebar_opts)
    catch
      { :error, :failed } -> exit(1)
      other ->
        IO.puts "Unexpected error in rebar: #{other}"
        exit(1)
    end
  end

  def consult_exs(file) do
    case File.read(file) do
      { :ok, contents } ->
        { res, _ } = Code.eval File.read!(file), [], file: file
        { :ok, res }
      other -> other
    end
  end

  defp rebar_opts do
    [
      plugins: [Mix.Rebar.Compiler],
      rebar_config_formats: [
        { 'rebar.exs', { __MODULE__, :consult_exs } }
      ]
    ]
  end
end