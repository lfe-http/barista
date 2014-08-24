(defmodule barista
  (import
    (from proplists
      (get_value 2))
    (from lmug
      (host->tuple 1)))
  (export all))

(defun setup ()
  )

(defun run-barista (handler options)
  (inets:start)
  (setup)
  (inets:start 'httpd
    (barista-options:fixup options)))

(defun stop-barista
  ((pid) (when (is_pid pid))
   (inets:stop 'httpd pid))
  ((options)
    (stop-barista
      (get_value 'host options)
      (get_value 'port options))))

(defun stop-barista
  (('pid pid)
    (inets:stop 'httpd pid))
  ((host port)
    (inets:stop 'httpd `#(,(host->tuple host) ,port))))
