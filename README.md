# barista

*Barista serves up hot lmugs of LFE for your simple LFE-native HTTP needs.*

<img src="resources/images/barista.png" />


## Introduction

Barista is a stand-alone, simple HTTP server. Or more accurately, barista
is LFE code that wraps the Erlang/OTP ``httpd`` HTTP server. It is intended
for a couple of simple uses:

* development and demo purposes
* quickly and easily testing of lmug middleware

This is the first HTTP server which supports the
[lmug Spec](https://github.com/lfex/lmug/blob/master/doc/SPEC.md) for creating
HTTP middleware (and lmug-compliant HTTP servers) in Erlang/LFE.

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

NOTE: barista by itself isn't very compelling; it's just a convenient LFE
wrapper around Erlang/OTP's ``httpd``. It's much more meaningful when used
as part of lmug.

As such, keep in mind that the following usage is "toy"; see the
[lmug](https://github.com/lfex/lmug) project for more interesting use cases.

```bash
$ make repl
```

Then, from the LFE REPL:

```cl
> (defun handler (request) "Wassup?")
handler
> (set `#(ok ,pid) (barista:start-barista #'handler/1))
#(ok <0.46.0>)
```

Or, if you want to start barista on a non-default port (something other than
1206), you can do this instead:

```cl
(barista:start-barista #'handler/1 '(#(port 8000)))
#(ok <0.46.0>)
```

Then, make a request:

```bash
$ curl -D- -X GET http://localhost:1206/
HTTP/1.1 200 OK
Server: inets/5.10
Content-Type: text/html
Date: Tue, 26 Aug 2014 04:02:57 GMT
Content-Length: 9

"Wassup?"
```

Instead of replacing the request data with a string, let's pass the data:

```cl
> (barista:stop-barista pid)
ok
> (defun handler (request) request)
handler
> (set `#(ok ,pid) (barista:start-barista #'handler/1))
#(ok <0.56.0>)
```

Let's try this one out:

```bash
$ curl -D- -X PUT http://localhost:1206/a/b/c
HTTP/1.1 200 OK
Server: inets/5.10
Content-Type: text/html
Date: Tue, 26 Aug 2014 03:59:47 GMT
Content-Length: 277

{mod,{init_data,{51709,"127.0.0.1"},"korax-4"},
     [],ip_comm,#Port<0.3331>,httpd_conf__127_0_0_1__1206,"PUT",
     "localhost:1206/a/b/c","/a/b/c","HTTP/1.1","PUT /a/b/c HTTP/1.1",
     [{"accept","*/*"},{"host","localhost:1206"},{"user-agent","curl/7.30.0"}],
     [],true}
```
