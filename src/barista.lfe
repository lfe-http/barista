(defmodule barista
  (import
    (from proplists
      (get_value 2))
    (from lmug
      (host->tuple 1)))
  (export all))

(defun lmug-handler-name () 'lmug-handler)

(defun setup ()
  (lutil-file:mkdirs (lcfg:get-in '(barista httpd-conf log-dir)))
  (lutil-file:mkdirs (lcfg:get-in '(barista httpd-conf docroot))))

(defun get-config ()
  (httpd:info (get-httpd)))

(defun start ()
  (start (lambda (request) request) '()))

(defun start (handler)
  (start handler '()))

(defun start (handler options)
  "Given a handler which maps request records to response records, pass the
  response data off to OTP httpd so that it may generate the HTTP server
  response.

  This function starts up the handler-loop, passing it the handler function.
  The spawned handler loop PID is then registered for use with later calls."
  (inets:start)
  (setup)
  (start-listener handler)
  (start-httpd options))

(defun start-listener (handler)
  (case (spawn 'barista 'handler-loop `(,handler))
    (pid
     (register (lmug-handler-name) pid))))

(defun start-httpd (options)
  (case (inets:start 'httpd (barista-options:fixup options))
    (`#(ok ,pid)
     'ok)
    (other
     other)))

(defun handler-loop (handler-fn)
  "This function is called when a barista server is started. It then listens
  for data messages. When received, calls the handler function (passed when
  the barista server was started) and sends the results of that call to the
  function that called the loop (e.g., the do/1 function for barista/httpd,
  and the out/1 function for YAWS)."
  (io:format "Starting handler loop ...~n")
  (receive
    (`#(,sender-pid ,data)
      (! sender-pid `#(handler-output ,(funcall handler-fn data)))
      (handler-loop handler-fn))))

(defun do (httpd-mod-data)
  "This is the function that the Erlang/OTP httpd server calls on every request
  for each of the registered modules. In order for this to work, the barista
  HTTP server needs to be configured with #(modules (... barista)) at the end.

  Note that, in order to call the handler here, we need to set up a 'handler
  server' when we call the 'start' function. This will allow us to call
  the configured handler later (i.e., here in the 'do' function).

  This function does the following, when it is called (on each HTTP request):

   * looks up the PID for the handler loop
   * calls the middleware function that converts the Erlang/OTP httpd arg data
     to lmug request data
   * sends a message to the handler loop with converted request data
   * sets up a listener that will be called by the handler loop
   * waits to reveive data from the handler loop (the data which will have been
     produced by the handler function passed to start/1 or start/2)
   * converts the passed lmug request data to the format expected by
     Erlang/OTP httpd
  "
  (! (lmug-handler-name) `#(,(self) ,httpd-mod-data))
  (receive
    (`#(handler-output ,data)
     `#(proceed
        (#(response
           #(200 ,(io_lib:format "~p" (list data)))))))
    (`#(error enoent)
     `#(proceed
        (#(response
           #(404 "Not Found")))))
    (x
     (io:format "Unexpected result: ~p~n" `(,x)))))

(defun stop ()
  (inets:stop 'httpd (get-httpd))
  (exit (get-handler) 'ok)
  'ok)

(defun get-handler ()
  (whereis (lmug-handler-name)))

(defun get-httpd ()
  (case (lists:keyfind 'httpd 1 (inets:services_info))
    (`#(httpd ,pid ,_)
     pid)))
