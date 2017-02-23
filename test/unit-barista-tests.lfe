(defmodule unit-barista-tests
  (behaviour ltest-unit)
  (export all))

(include-lib "ltest/include/ltest-macros.lfe")

(deftest code-change
  (is-equal
    'lmug-handler
    (barista:lmug-handler-name)))
