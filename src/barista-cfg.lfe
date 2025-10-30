(defmodule barista-cfg
  (export
   (default 0)
   (options 0) (options 1)))

(defun default ()
  "Return default httpd configuration options.

   Returns:
     Property list of httpd options"
  `#m(port 8080
      server_name "barista"
      server_root "."
      document_root "."
      bind_address any
      ;;profile default
      ;;socket_type ip_comm
      ;;ipfamily inet
      ;;minimum_bytes_per_second 1024
      ;;max_body_size ,(* 10 (math:pow 1024 3))
      modules (mod_alias mod_auth mod_dir mod_get mod_auth
	       mod_log mod_disk_log mod_esi)
      mime_types (#("html" "text/html")
	          #("htm" "text/html")
	          #("css" "text/css")
	          #("js" "application/x-javascript")
	          #("json" "application/json")
	          #("png" "image/png")
	          #("jpg" "image/jpeg"))))

(defun options ()
  (options `#m()))

(defun options (overrides)
  (maps:merge (default) overrides))
