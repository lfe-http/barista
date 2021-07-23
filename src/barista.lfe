(defmodule barista
  (export
   (default-options 0)
   (read-config 1)
   (response 1) (response 2) (response 3)
   (start 0) (start 1)
   (stop 1)))

(include-lib "kernel/include/logger.hrl")

(defun default-options ()
  '(#(port 5099)
    #(server_name "barista-passthrough")
    #(document_root ".")
    #(server_root ".")
    #(modules (barista-passthrough))))

(defun read-config (config-file)
  "Read a standard release-style system config file.

  Essentially wraps file:consult/1."
  (let ((`#(ok (,cfg)) (file:consult config-file)))
    cfg))

(defun get-opts (overrides)
  (let ((config-file (proplists:get_value 'config-file overrides 'no-config))
        (config-keys (proplists:get_value 'config-keys overrides '(inets services httpd))))
    (if (== 'no-config config-file)
      (default-options)
      (case (clj:get-in (read-config config-file) config-keys)
        ('undefined '())
        (opts opts)))))

(defun response (body) (barista-resposne:response body))
(defun response (status body) (barista-resposne:response status body))
(defun response (status headers body) (barista-resposne:response status headers body))

(defun start ()
  (start '()))

(defun start (overrides)
  (let* ((opts (++ overrides (get-opts overrides))))
    (LOG_DEBUG "httpd options: ~p~n" (list opts))
    (inets:start 'httpd opts)))

(defun stop (pid)
  (inets:stop 'httpd pid))
