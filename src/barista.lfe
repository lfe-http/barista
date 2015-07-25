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

(defun run-barista (handler)
  (run-barista handler '()))

(defun run-barista
  ;; Given a handler which maps request records to response records, pass the
  ;; response data off to OTP httpd so that it may generate the HTTP server
  ;; response.
  ;;
  ;; This function starts up the handler-loop, passing it the handler function.
  ;; The spawned handler loop PID is then registered for use with later calls.
  ((handler options) (when (is_function handler))
    (inets:start)
    (setup)
    (let ((pid (spawn 'barista 'handler-loop `(,handler))))
      (register (lmug-handler-name) pid))
    (inets:start
      'httpd
      (barista-options:fixup options))))

(defun handler-loop (handler-fn)
  "This function is called when a barista server is started. It then listens
  for data messages. When received, calls the handler function (passed when
  the barista server was started) and sends the results of that call to the
  function that called the loop (e.g., the do/1 function for barista/httpd,
  and the out/1 function for YAWS)."
  (io:format "Starting handler loop ...~n")
  (receive
    ((tuple sender-pid data)
      (! sender-pid `#(handler-output ,(funcall handler-fn data)))
      (handler-loop handler-fn))))

(defun do (httpd-mod-data)
  "This is the function that the Erlang/OTP httpd server calls on every request
  for each of the registered modules. In order for this to work, the barista
  HTTP server needs to be configured with #(modules (... barista)) at the end.

  Note that, in order to call the handler here, we need to set up a 'handler
  server' when we call the 'run' function. This will allow us to call the
  configured handler later (i.e., here in the 'do' function).

  This function does the following, when it is called (on each HTTP request):

   * looks up the PID for the handler loop
   * calls the middleware function that converts the Erlang/OTP httpd arg data
     to lmug request data
   * sends a message to the handler loop with converted request data
   * sets up a listener that will be called by the handler loop
   * waits to reveive data from the handler loop (the data which will have been
     produced by the handler function passed to run-barista/1 or run-barista/2)
   * converts the passed lmug request data to the format expected by
     Erlang/OTP httpd
  "
  (let ((handler-pid (whereis (lmug-handler-name))))
    (! handler-pid (tuple (self) httpd-mod-data))
    (receive
      ((tuple 'handler-output data)
        `#(proceed
          (#(response
             #(200 ,(io_lib:format "~p" (list data)))))))
      ((tuple 'error 'enoent)
       `#(proceed
          (#(response
             #(404 "Not Found")))))
      (x (io:format "Unexpected result: ~p~n" `(,x))))))

(defun stop-barista
  ((pid) (when (is_pid pid))
   (inets:stop 'httpd pid)
   (exit (whereis (lmug-handler-name)) 'ok)
   'ok)
  ((options)
    (stop-barista
      (get_value 'host options)
      (get_value 'port options))))

(defun stop-barista
  (('pid pid)
    (inets:stop 'httpd pid)
    (exit (whereis (lmug-handler-name)) 'ok)
    'ok)
  ((host port)
    (inets:stop 'httpd `#(,(host->tuple host) ,port))
    (exit (whereis (lmug-handler-name)) 'ok)
    'ok))
