(defmodule barista-options
  (import
    (from proplists
      (delete 2)
      (get_value 2))
    (from lutil-type
      (rename-key 3)))
  (export all))

(include-lib "clj/include/compose.lfe")

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
    `(#(host ,(lcfg:get-in '(barista httpd-conf host)))
      #(port ,(lcfg:get-in '(barista httpd-conf port)))
      #(server-name ,(lcfg:get-in '(barista httpd-conf server-name)))
      #(server-root ,(basedir))
      #(error-log ,(filename:join (log-dir)
                                  (lcfg:get-in '(barista httpd-conf error-log))))
      #(access-log ,(filename:join (log-dir)
                                   (lcfg:get-in '(barista httpd-conf access-log))))
      #(docroot ,(docroot))
      #(ipfamily inet)
      #(modules (mod_alias mod_auth mod_actions mod_dir
                 mod_get mod_head mod_log mod_disk_log barista)))))

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
