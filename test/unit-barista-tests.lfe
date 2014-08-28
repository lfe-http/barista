(defmodule unit-barista-tests
  (behaviour ltest-unit)
  (export all)
  (import
    (from ltest
      (check-failed-assert 2)
      (check-wrong-assert-exception 2))))

(include-lib "deps/ltest/include/macros.lfe")

(deftest code-change
  (is-equal
    ;; XXX This unit test fails by default -- fix it!
    #(ok "data")
    (: barista-server code_change
       '"old version"
       '"state"
       '"extra")))
