# barista

[![Build Status][gh-actions-badge]][gh-actions]
[![LFE Versions][lfe badge]][lfe]
[![Erlang Versions][erlang badge]][versions]
[![Tags][github tags badge]][github tags]
[![Downloads][hex downloads]][hex package]

[![][project-logo]][project-logo-large]

*Barista serves up hot lmugs of LFE for your simple LFE-native HTTP needs.*

#### Contents

* [Introduction](#introduction-)
* [Installation](#installation-)
* [Usage](#usage-)
* [Creating Custom Modules](#creating-custom-modules-)
* [License](#license-)

## Introduction [&#x219F;](#contents)

Barista is a stand-alone, simple HTTP server. Or more accurately, barista
is LFE code that wraps the Erlang/OTP ``httpd`` HTTP server. It is intended
for development/demo purposes and non-critical services.

## Installation [&#x219F;](#contents)

Just add it to your ``rebar.config`` deps:

```erlang
    {deps, [
        {barista, "0.3.0"}
    ]}.
```

And then do the usual:

```bash
    rebar3 compile
```

## Usage [&#x219F;](#contents)

To try out the default no-op/pass-through handler, you can do this (after `rebar3 compile`):

```bash
rebar3 lfe repl
```

```cl
lfe> (set `#(ok ,svr) (barista:start))
```

This will start an HTTP server with the default barista options. You can use `curl` to try it out:

``` bash
curl "http://localhost:5099/"
```

or

``` bash
curl -XPOST \
     -H "Content-Type: application/x-www-form-urlencoded" \
     -d "c=3&d=42" \
     "http://localhost:5099/order?a=1&b=2"
```

You can override the default options like so:

``` cl
lfe> (set `#(ok ,svr) (barista:start '(#(port 9099))))
```

Additionally, you can provide a config file that may be used to provide options for starting up
barista (which is really the inets httpd service):

``` cl
lfe> (set `#(ok ,svr) (barista:start '(#(config-file "configs/sys.config"))))
```

That expects the inets httpd configuration to be in a nested proplist under the following:

``` erlang
[{inets,
 [{services,
  [{httpd, ... }]}]}].
```

If your configuration is in a different part of the configuration, you just need to supply a list
of the keys that point to it, e.g.:

``` cl
lfe> (set `#(ok ,svr) (barista:start '(#(config-file "configs/sys.config")
                                       #(config-keys (my-app httpd)))))
```

Finally, to stop barista:

``` cl
lfe> (barista:stop svr)
```

## Creating Custom Modules [&#x219F;](#contents)

The Erlang inets httpd server supports the creation of modules (see [the documentation](http://erlang.org/doc/apps/inets/http_server.html#inets-web-server-modules) for the various `mod_*` httpd modules). The example module `barista-passthrough` implements the httpd module contract: a single `do/1` function is all that is needed. The argument it takes is the inets httpd request record `mod` found in `inets/include/httpd.hrl`.

In addition to this, the `barista-passthrough` defines a `handle/3` function very much in line with the sort of thing that [Elli](https://github.com/elli-lib/elli) developers do when creating routes for their web applications.

## License [&#x219F;](#contents)

Copyright © 2014-2021, Duncan McGreggor

Apache License, Version 2.0

[//]: ---Named-Links---

[project-logo]: priv/images/barista.png
[project-logo-large]: priv/images/barista.png
[gh-actions-badge]: https://github.com/lfex/barista/workflows/ci%2Fcd/badge.svg
[gh-actions]: https://github.com/lfex/barista/actions
[lfe]: https://github.com/lfe/lfe
[lfe badge]: https://img.shields.io/badge/lfe-2.1-blue.svg
[erlang badge]: https://img.shields.io/badge/erlang-21%20to%2025-blue.svg
[versions]: https://github.com/lfex/barista/blob/master/.github/workflows/cicd.yml
[github tags]: https://github.com/lfex/barista/tags
[github tags badge]: https://img.shields.io/github/tag/lfex/barista.svg
[hex package]: https://hex.pm/packages/barista
[hex downloads]: https://img.shields.io/hexpm/dt/barista.svg
