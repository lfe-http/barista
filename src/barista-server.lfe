;;;-------------------------------------------------------------------
;;; @author  YOUR NAME, <YOUR EMAIL>
;;; @copyright (C) YEAR,
;;; @doc
;;;     YOUR PROJECT application server
;;; @end
;;; Created : TODAY by YOUR EMAIL
;;;-------------------------------------------------------------------
(defmodule barista-server
  (behaviour gen_server)
  ;; API
  (export (start_link 0)
          (test-call 1)
          (test-cast 1))
  ;; gen_server callbacks
  (export (init 1)
          (handle_call 3)
          (handle_cast 2)
          (handle_info 2)
          (terminate 2)
          (code_change 3)))

(defrecord state
  (data (tuple)))

(defun server-name ()
  'barista-server)

;;;===================================================================
;;; API
;;;===================================================================

;;--------------------------------------------------------------------
;; @doc
;; Starts the server
;;
;; @spec start_link() -> {ok, Pid} | ignore | {error, Error}
;; @end
;;--------------------------------------------------------------------
(defun start_link ()
  (: gen_server start_link
     (tuple 'local (server-name)) (MODULE) '() '()))

(defun test-call (message)
  (: gen_server call
     (server-name) (tuple 'test message)))

(defun test-cast (message)
  (: gen_server cast
     (server-name) (tuple 'test message)))

;;;===================================================================
;;; gen_server callbacks
;;;===================================================================

;;--------------------------------------------------------------------
;; @private
;; @doc
;; Initializes the server
;;
;; @spec init(Args) -> {ok, State} |
;;                     {ok, State, Timeout} |
;;                     ignore |
;;                     {stop, Reason}
;; @end
;;--------------------------------------------------------------------
(defun init (args)
  (tuple 'ok (make-state)))


;;--------------------------------------------------------------------
;; @private
;; @doc
;; Handling call messages
;;
;; @spec handle_call(Request, From, State) ->
;;                                   {reply, Reply, State} |
;;                                   {reply, Reply, State, Timeout} |
;;                                   {noreply, State} |
;;                                   {noreply, State, Timeout} |
;;                                   {stop, Reason, Reply, State} |
;;                                   {stop, Reason, State}
;; @end
;;--------------------------------------------------------------------
(defun handle_call
  (((tuple 'test message) from state)
    (: lfe_io format '"Call: ~p~n" (list message))
    (tuple 'reply 'ok state))
  ((request from state)
    (tuple 'reply 'ok state)))

;;--------------------------------------------------------------------
;; @private
;; @doc
;; Handling cast messages
;;
;; @spec handle_cast(Msg, State) -> {noreply, State} |
;;                                  {noreply, State, Timeout} |
;;                                  {stop, Reason, State}
;; @end
;;--------------------------------------------------------------------
(defun handle_cast
  (((tuple 'test message) state)
    (: lfe_io format '"Cast: ~p~n" (list message))
    (tuple 'noreply state))
  ((message state)
    (tuple 'noreply state)))

;;--------------------------------------------------------------------
;; @private
;; @doc
;; Handling all non call/cast messages
;;
;; @spec handle_info(Info, State) -> {noreply, State} |
;;                                   {noreply, State, Timeout} |
;;                                   {stop, Reason, State}
;; @end
;;--------------------------------------------------------------------
(defun handle_info (info state)
  (tuple 'noreply state))

;;--------------------------------------------------------------------
;; @private
;; @doc
;; This function is called by a gen_server when it is about to
;; terminate. It should be the opposite of Module:init/1 and do any
;; necessary cleaning up. When it returns, the gen_server terminates
;; with Reason. The return value is ignored.
;;
;; @spec terminate(Reason, State) -> void()
;; @end
;;--------------------------------------------------------------------
(defun terminate (reason state)
  'ok)

;;--------------------------------------------------------------------
;; @private
;; @doc
;; Convert process state when code is changed
;;
;; @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
;; @end
;;--------------------------------------------------------------------
(defun code_change (old-version state extra)
  (tuple 'ok state))

;;;===================================================================
;;; Internal functions
;;;===================================================================
