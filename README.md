# barista

*Barista serves up hot lmugs of LFE for your simple LFE-native HTTP needs.*

<img src="resources/images/barista.png" />


## Introduction

Barista is a stand-alone, simple HTTP server written in LFE for development
and demo purposes only. It was the first server written against the nascent
[lmug Spec](https://github.com/lfex/lmug/blob/master/doc/SPEC.md).

If you would like to use a production-ready HTTP server with lmug middleware,
be sure to check out the other options:

* [lmug-yaws](https://github.com/lfex/lmug-yaws) (in development)
* [lmug-cowboy](https://github.com/lfex/lmug-cowboy) (in development)


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

NOTE: the code in this section doesn't work yet! One of the first goals is to
get to this point :-)

The best way to demonstrate barista is in conjunction with lmud:

```bash
$ git clone https://github.com/lfex/lmug.git
$ cd lmud
$ make repl
```

Then, from the LFE REPL:

```cl
> (slurp "src/lmug.lfe")
#(ok lmug)
> (defun handler (request)
    (make-response
      status 200
      headers (#("Content-Type" "text/plain"))
      body "Hello World"))

> (set `#(ok ,pid) (barista:run-barista #'handler/1))
#(ok <0.46.0>)
```

Or, if you want to run on a non-default port (something other than 1206):

```cl
(barista:run-barista #'handler/1 '(#(port 8000)))
#(ok <0.54.0>)
```

