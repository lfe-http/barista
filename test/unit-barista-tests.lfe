(defmodule unit-barista-tests
  (behaviour lunit-unit)
  (export all)
  (import
    (from lunit
      (check-failed-assert 2)
      (check-wrong-assert-exception 2))))

(include-lib "deps/lunit/include/lunit-macros.lfe")

(deftest code-change
  (is-equal
    ;; XXX This unit test fails by default -- fix it!
    #(ok "data")
    (: barista-server code_change
       '"old version"
       '"state"
       '"extra")))
