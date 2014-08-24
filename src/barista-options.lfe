(defmodule barista-options
  (import
    (from proplists
      (delete 2)
      (get_value 2))
    (from lmug
      (add-default 3)
      (host->tuple 1)
      (rename-key 3)))
  (export all))

(include-lib "lutil/include/compose-macros.lfe")

(defun base-dir () '"./")
(defun log-dir () '"log")
(defun http-dir () '"www")

(defun get-defaults ()
  (orddict:from_list
    `(#(host "localhost")
      #(port 1206)
      #(server-name "barista_dev")
      #(server-root ,(base-dir))
      #(error-log ,(++ (log-dir) "/errors.log"))
      #(access-log ,(++ (log-dir) "/access.log"))
      #(docroot ,(http-dir))
      #(index-files ("index.html", "index.htm"))
      #(ipfamily inet))))

(defun add-defaults (options)
  (merge (get-defaults)
         options))

(defun merge (options1 options2)
  "That which is added latter will over-write what was previous. As such,
  options2 has presedence over options1."
  (orddict:merge
    #'second-wins/3
    options1
    options2))

(defun second-wins (key val1 val2)
  val2)

(defun fixup (options)
  "Let's rename the lmud-standard keys to ones that the OTP httpd module
  expects to see."
  (->> (orddict:from_list options)
       (add-defaults)
       (rename-key 'host 'bind_address)
       (rename-key 'docroot 'document_root)
       (rename-key 'index-files 'directory_index)
       (rename-key 'server-name 'server_name)
       (rename-key 'server-root 'server_root)
       (rename-key 'access-log 'transfer_log)
       (rename-key 'error-log 'error_log)))
