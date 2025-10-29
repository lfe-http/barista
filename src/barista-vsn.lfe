(defmodule barista-vsn
  (export all))

(defun get ()
  (barista-vsn:get 'barista))

(defun get (app-name)
  (application:load app-name)
  (case (application:get_key app-name 'vsn)
    (`#(ok ,vsn) vsn)
    (default default)))

(defun version-arch ()
  `#(architecture ,(erlang:system_info 'system_architecture)))

(defun version+name (app-name)
  `#(,app-name ,(barista-vsn:get app-name)))

(defun versions-rebar ()
  `(,(version+name 'rebar)
    ,(version+name 'rebar3_lfe)))

(defun versions-langs ()
  `(,(version+name 'lfe)
    #(erlang ,(erlang:system_info 'otp_release))
    #(emulator ,(erlang:system_info 'version))
    #(driver ,(erlang:system_info 'driver_version))))

(defun all ()
  (lists:append `((,(version+name 'barista))
                  ,(versions-langs)
                  ,(versions-rebar)
                  (,(version-arch)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun parse-body
  (("application/x-www-form-urlencoded" body)
   (yuri.query:parse body))
  ((_ body)
   body))
