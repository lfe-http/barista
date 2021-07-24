(defmodule barista-response
  (export all))

(defun response (body)
  (response 200 body))

(defun response (status body)
  (response status '() body))

(defun response (status headers body)
  `#(proceed
     #(response
       #(,status ,(string:join (++ headers (list body)) "\r\n")))))

(defun accepted ()
  (accepted "Accepted"))

(defun accepted (body)
  (response 202 body))

(defun created ()
  (created "Created"))

(defun created (body)
  (response 201 body))

(defun ok ()
  (ok "OK"))

(defun ok (body)
  (response 200 body))

(defun method-not-allowed ()
  (method-not-allowed "Method Not Allowed"))

(defun method-not-allowed (body)
  (response 405 body))

(defun no-content ()
  (no-content "No Content"))

(defun no-content (body)
  (response 204 body))

(defun not-found ()
  (not-found "Not Found"))

(defun not-found (body)
  (response 404 body))
