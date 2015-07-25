(defmodule barista-options
  (import
    (from proplists
      (delete 2)
      (get_value 2))
    (from lutil-type
      (rename-key 3)))
  (export all))

(include-lib "clj/include/compose.lfe")

(defun get-defaults ()
  (orddict:from_list
    `(#(host ,(lcfg:get-in '(barista httpd-conf host)))
      #(port ,(lcfg:get-in '(barista httpd-conf post)))
      #(server-name ,(lcfg:get-in '(barista httpd-conf server-name)))
      #(server-root ,(lcfg:get-in '(barista httpd-conf server-root)))
      #(error-log ,(filename:join (lcfg:get-in '(barista httpd-conf log-dir))
                                  (lcfg:get-in '(barista httpd-conf error-log))))
      #(access-log ,(filename:join (lcfg:get-in '(barista httpd-conf log-dir))
                                   (lcfg:get-in '(barista httpd-conf access-log))))
      #(docroot ,(lcfg:get-in '(barista httpd-conf docroot)))
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
       (rename-key 'server-name 'server_name)
       (rename-key 'server-root 'server_root)
       (rename-key 'access-log 'transfer_log)
       (rename-key 'error-log 'error_log)
       (rename-key 'nocache 'erl_script_nocache)))
