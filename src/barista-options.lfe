(defmodule barista-options
  (import
    (from proplists
      (delete 2)
      (get_value 2))
    (from lutil-type
      (rename-key 3)))
  (export all))

(defun get-cwd ()
  (case (file:get_cwd)
    (`#(ok ,dir) dir)
    (x x)))

(defun basedir ()
  (let ((basedir (lcfg:get-in '(barista httpd-conf server-root))))
    (case (car basedir)
      (#\/ basedir)
      (_ (filename:join (get-cwd) basedir)))))

(defun docroot ()
  (let ((docroot (lcfg:get-in '(barista httpd-conf docroot))))
    (case (car docroot)
      (#\/ docroot)
      (_ (filename:join (get-cwd) docroot)))))

(defun log-dir ()
  (filename:join (basedir)
                 (lcfg:get-in '(barista httpd-conf log-dir))))

(defun get-defaults ()
  (orddict:from_list
    `(#(ipfamily inet)
      #(modules (mod_alias mod_auth mod_actions mod_dir
                 mod_get mod_head mod_log mod_disk_log barista)))))

(defun add-defaults (options)
  (lutil-type:orddict-merge (get-defaults)
                            options))

(defun get-config ()
  (orddict:from_list (lcfg:get-in '(barista httpd-conf))))

(defun add-config (options)
  (lutil-type:orddict-merge (get-config)
                            options))

(defun get-computed ()
  (orddict:from_list
    `(#(server-root ,(basedir))
      #(error-log ,(filename:join (log-dir)
                                  (lcfg:get-in '(barista httpd-conf error-log))))
      #(access-log ,(filename:join (log-dir)
                                   (lcfg:get-in '(barista httpd-conf access-log))))
      #(docroot ,(docroot)))))

(defun add-computed (options)
  (lutil-type:orddict-merge (get-computed)
                            options))

(defun fixup (options)
  "Let's rename the lmug-standard keys to ones that the OTP httpd module
  expects to see."
  (clj:->> (orddict:from_list options) ; user options override all
           (add-computed)              ; computed options from the config file are next
           (add-config)                ; non-computed config items are lesser prio
           (add-defaults)              ; defaults have the least prio
           (rename-key 'host 'bind_address)
           (rename-key 'docroot 'document_root)
           (rename-key 'server-name 'server_name)
           (rename-key 'server-root 'server_root)
           (rename-key 'access-log 'transfer_log)
           (rename-key 'error-log 'error_log)
           (rename-key 'mime-types 'mime_types)
           (rename-key 'index-files 'directory_index)
           (rename-key 'nocache 'erl_script_nocache)))
