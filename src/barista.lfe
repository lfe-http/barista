(defmodule barista
  (export
   (default-options 0)
   (read-config 1)
   (start 0) (start 1)
   (stop 0)
   (version 0)))

(include-lib "kernel/include/logger.hrl")

(defun default-options ()
  '(#(port 5099)
    #(server_name "barista")
    #(document_root ".")
    #(server_root ".")))

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

(defun app ()
  (clj:-> (lmug:app)
          (lmug-mw-identity:wrap)
          (lmug-mw-request-id:wrap)
          (lmug-mw-content-type:wrap)
          (lmug-mw-status-body:wrap)))

(defun start ()
  (start '()))

(defun start (overrides)
  (let ((inets-opts (++ overrides (get-opts overrides))))
    (lmug-inets:start (app) inets-opts)))

(defun stop ()
  (lmug-inets:stop))

(defun version ()
  (barista-vsn:get))

(defun versions ()
  (barista-vsn:all))
