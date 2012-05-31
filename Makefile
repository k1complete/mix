default: compile

setup:
	git submodule update --init
	cd rebar && ./bootstrap
	mkdir -p ebin
	cp -R rebar/ebin/ ebin/

compile:
	@ elixirc "lib/**/*.ex" -o ebin

clean:
	@ rm -rf ebin

test: compile
	@ time elixir -pa ebin/ -r "test/**/*_test.exs"

