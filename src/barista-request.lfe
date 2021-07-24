(defmodule barista-request
  (export
   (->map 1)
   (get-data 1)))

(include-lib "inets/include/httpd.hrl")

(defun ->map
  "This function takes an inets httpd request (mod record),  converts it to 
  a map, and adds a bit more data to it, after parsing some of the request
  data."
  (((match-mod init_data id data d socket_type st socket s config_db cdb
               method m absolute_uri au request_uri ru http_version hv
               request_line rl parsed_header ph entity_body eb connection c))
   (let* ((headers (maps:from_list ph))
          (pu (uri_string:parse ru))
          (query (barista-util:parse-query (maps:get 'query pu ""))))
   `#m(init=data #m(peername ,(init_data-peername id)
                    sockname ,(init_data-sockname id)
                    resolve ,(init_data-resolve id))
       data ,d
       socket-type ,st
       socket ,s
       config-db ,cdb
       method ,(list_to_atom m)
       absolute-uri ,au
       request-uri ,ru
       http-versions ,hv
       request-line ,rl
       headers ,headers
       body ,eb
       parsed-body ,(barista-util:parse-body (maps:get "content-type" headers "") eb)
       connection ,c
       path ,(lanes.util:path->segments (mref pu 'path))
       query ,query))))

(defun get-data (req)
  (mref req 'parsed-body))
