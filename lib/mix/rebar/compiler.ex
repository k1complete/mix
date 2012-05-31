defmodule Mix.Rebar.Compiler do
  alias :rebar_config, as: RebarConfig

  def compile(_config, _appfile) do
    # TODO: remove hardcoded lib
    source        = File.wildcard(File.join [get_cwd, "lib/**/*.ex"])
    last_modified = Enum.reduce(source, 0, fn(file, acc) -> max(last_modified(file), acc) end)

    # TODO: remove hardcoded ebin
    target   = File.join [get_cwd, "ebin"]
    compiled = File.wildcard(File.join [target, "__MAIN__/**/*.beam"])

    # TODO: Support elixir options
    # Code.compiler_options()

    if compiled == [] or any_stale?(compiled, last_modified) do
      # TODO: remove hardcoded clean up
      # TODO: Use File.rm_rf when available
      System.cmd("rm -rf #{target}/__MAIN__")

      File.mkdir_p target

      try do
        Elixir.ParallelCompiler.files_to_path source, target, fn(x) ->
          IO.puts ["Compiled ", x]
        end
      rescue
        exception ->
          IO.puts :standard_error, "** (#{inspect exception.__record__(:name)}) #{exception.message}"
          print_stacktrace System.stacktrace
          throw { :error, :failed }
      end
    end

    :ok
  end

  defp any_stale?(compiled, last_modified) do
    Enum.any?(compiled, fn(file) -> last_modified(file) < last_modified end)
  end

  defp get_cwd do
    { :ok, dir } = :file.get_cwd
    list_to_binary(dir)
  end

  defp last_modified(file) do
    File.read_info!(file).mtime
  end

  defp print_stacktrace(stacktrace) do
    Enum.each stacktrace, fn s ->
      IO.puts :standard_error, "    #{Exception.format_stacktrace(s)}"
    end
  end
end