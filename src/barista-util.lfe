(defmodule barista-util
  (export all))

(defun get-barista-version ()
  (lutil:get-app-src-version "src/barista.app.src"))

(defun get-version ()
  (++ (lutil:get-version)
      `(#(barista ,(get-barista-version)))))

; -record(mod,{init_data,
;              data=[],
;              socket_type=ip_comm,
;              socket,
;              config_db,
;              method,
;              absolute_uri=[],
;              request_uri,
;              http_version,
;              request_line,
;              parsed_header=[],
;              entity_body,
;              connection}).

(defun httpd->lmug-response (data)
  data)

(defun lmug->httpd-response (data)
  data)

; (defrecord request
;   (server-port 1206)
;   (server-name "")
;   (remote-addr "")
;   (uri "")
;   query-string
;   (scheme "")
;   (request-method 'get)
;   content-type
;   content-length
;   content-encoding
;   ssl-client-cert
;   (headers '())
;   body)
