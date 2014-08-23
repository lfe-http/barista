# barista

*Barista serves up hot lmugs of LFE for your simple LFE-native HTTP needs.*

## Introduction

Barista is a stand-alone, simple HTTP server written in LFE for development
and demo purposes only. It was the first server written against the nascent
[lmug Spec](https://github.com/lfex/lmug/blob/master/doc/SPEC.md).

If you would like to use a production-ready HTTP server with lmud middleware,
be sure to check out the other options:

* [lmud-yaws](https://github.com/lfex/lmug-yaws)
* [lmud-cowboy](https://github.com/lfex/lmug-cowboy)


## Installation


Just add it to your ``rebar.config`` deps:

```erlang
    {deps, [
        ...
        {barista, ".*", {git, "git@github.com:lfex/barista.git", "master"}}
      ]}.
```

And then do the usual:

```bash
    $ rebar get-deps
    $ rebar compile
```

## Usage

Add content to me here!
