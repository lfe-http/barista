(defmodule barista-response-tests
  (behaviour ltest-unit)
  (export all))

(include-lib "ltest/include/ltest-macros.lfe")

(deftest proceed
  (is-equal #(proceed (#(response #(200 "OK"))))
            (barista-resposne:proceed 200 '() "OK")))

(deftest response-1
  (is-equal #(proceed #(response #(200 "OK")))
            (barista-response:response "OK")))

(deftest response-2
  (is-equal #(proceed #(response #(222 "OK")))
            (barista-response:response 222 "OK")))

(deftest response-3
  (is-equal #(proceed #(response #(42 "head\r\ner\r\nOK")))
            (barista-response:response 42 '("head" "er") "OK")))

(deftest ok-0
  (is-equal #(proceed #(response #(200 "OK")))
            (barista-response:ok)))

(deftest not-found-0
  (is-equal #(proceed #(response #(404 "Not Found")))
            (barista-response:not-found)))