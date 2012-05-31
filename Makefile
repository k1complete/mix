compile:
	@ elixirc "lib/**/*.ex" -o ebin

clean:
	@ rm -rf ebin

test: compile
	@ time elixir -pa ebin/ -r "test/**/*_test.exs"

