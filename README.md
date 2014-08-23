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

```cl
(defmodule hello-world
  (import
    (from barista (run-barista 2)))
  (export all))

(include-file "deps/lmug/include/response.lfe")

(defun handler (request)
  (make-response
    status 200
    headers (#("Content-Type" "text/plain"))
    body "Hello World"))

(run-barista #'handler/1 `(#(port 1206)))
```
