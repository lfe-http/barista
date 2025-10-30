(defmodule barista
  (export
   (start 0) (start 1)
   (stop 0) (stop 1)
   (pid 0)
   (info 0)
   (version 0) (versions 0)))

(include-lib "kernel/include/logger.hrl")

;; Server state tracking
(defun server-key () 'barista-server-pid)

(defun start ()
  "Start barista server with default options."
  (start '#m()))

(defun start
  "Start barista server with custom options.

     Args:
       opts: Map of server options (gets merged with defaults)

     Returns:
       #(ok pid) or error tuple"
 ((`#(file ,config-file))
  (application:ensure_all_started 'inets)
  (let ((result (inets:start 'httpd `(#(proplist_file ,config-file)))))
    (handle-start result)))
 ((opts)
  (application:ensure_all_started 'inets)
  (let* ((config (barista-cfg:options opts))
         (result (inets:start 'httpd (maps:to_list config))))
    (handle-start result))))

(defun handle-start
  ((`#(ok ,pid))
   (erlang:put (server-key) pid)
   (let* ((cfg (httpd:info pid))
          (port (proplists:get_value 'port cfg)))
     (LOG_INFO "Barista server started on port ~p" (list port))))
  ((error)
   (LOG_ERROR "Failed to start barista server: ~p" (list error))
   error))

(defun stop ()
  "Stop the barista server started by this process."
  (case (erlang:get (server-key))
    ('undefined
     `#(error not-running))
    (pid
     (stop pid))))

(defun stop (pid)
  "Stop barista server by PID.

     Args:
       pid: Server process ID

     Returns:
       ok or error tuple"
  (let ((result (inets:stop 'httpd pid)))
    (erlang:erase (server-key))
    result))

(defun pid ()
  "Get the PID of the barista server started by this process."
  (erlang:get (server-key)))

(defun info ()
  "Get the current server info map."
  (case (pid)
    ('undefined
     #(error not-running))
    (pid
     (httpd:info (pid)))))

;; Version info
(defun version ()
  (barista-vsn:get))

(defun versions ()
  (barista-vsn:all))
