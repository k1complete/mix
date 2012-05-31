#! /usr/bin/env mix

defmodule Mix.Project do
  def project do
    [name: "sample",
     version: "0.1.0",
     compile_options: [ignore_module_conflict: true, docs: true]]
  end
end
