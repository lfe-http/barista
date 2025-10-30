PROJECT = barista
ROOT_DIR = $(shell pwd)
REPO = $(shell git config --get remote.origin.url)
LFE = _build/default/lib/lfe/bin/lfe

include priv/make/code.mk
include priv/make/docs.mk

run: compile
	@erl -pa $(shell rebar3 path) -noshell -s inets -s barista start #(file "priv/config/example.conf")
