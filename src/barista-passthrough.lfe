(defmodule barista-passthrough
  (export
   (do 1)))

(defun do (httpd-req)
  (let ((req (barista-request:->map httpd-req)))
    (lfe_io:format "barista request: ~p~n" (list req))
    (handle (mref req 'method)
            (mref req 'path)
            req)))

(defun handle
  ((method path (= `#m(body ,body) req))
   "Example handler that displays whatever is passed through."
   (lfe_io:format "method: ~p~n" (list method))
   (lfe_io:format "path: ~p~n" (list path))
   (let* ((headers '("Content-Type: text/plain"
                     "Cache-Control: no-cache"
                     "Cache-Control: no-store"
                     "\r\n"))
          (body "hej!\r\n"))
     (lfe_io:format "headers: ~p~n" `(,headers))
     (lfe_io:format "body: ~p~n~n" `(,body))
     (barista:response 200 headers body))))
