(defmodule barista-util
  (export all))

(defun get-barista-version ()
  (lutil:get-app-src-version "src/barista.app.src"))

(defun get-version ()
  (++ (lutil:get-version)
      `(#(barista ,(get-barista-version)))))
