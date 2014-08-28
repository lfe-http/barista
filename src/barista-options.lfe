(defmodule barista-options
  (import
    (from proplists
      (delete 2)
      (get_value 2))
    (from lutil-type
      (rename-key 3)))
  (export all))

(include-lib "lutil/include/compose-macros.lfe")

(defun base-dir () '"./")
(defun log-dir () '"log")
(defun http-dir () '"www")
(defun index-file () '"index.html")

(defun get-defaults ()
  (orddict:from_list
    `(#(host "localhost")
      #(port 1206)
      #(server-name "barista_dev")
      #(server-root ,(base-dir))
      #(error-log ,(filename:join (log-dir) "errors.log"))
      #(access-log ,(filename:join (log-dir) "access.log"))
      #(docroot ,(http-dir))
      #(ipfamily inet)
      ;; #(nocache true)
      ;; #(modules (mod_alias mod_auth mod_esi mod_actions mod_cgi mod_dir
      ;;            mod_get mod_head mod_log mod_disk_log))
      #(modules (mod_log mod_disk_log barista))
      )))

(defun add-defaults (options)
  (lutil-type:orddict-merge (get-defaults)
                            options))

(defun fixup (options)
  "Let's rename the lmug-standard keys to ones that the OTP httpd module
  expects to see."
  (->> (orddict:from_list options)
       (add-defaults)
       (rename-key 'host 'bind_address)
       (rename-key 'docroot 'document_root)
       (rename-key 'index-files 'directory_index)
       (rename-key 'server-name 'server_name)
       (rename-key 'server-root 'server_root)
       (rename-key 'access-log 'transfer_log)
       (rename-key 'error-log 'error_log)
       (rename-key 'appmod 'erl_script_alias)
       (rename-key 'nocache 'erl_script_nocache)))
