(defmodule barista-tests
  (behaviour ltest-unit)
  (export all))

(include-lib "ltest/include/ltest-macros.lfe")

(defun test-req-data ()
  #(mod
    #(init_data
      #(62924 "127.0.0.1")
      #(5099 "127.0.0.1")
      "spacemac")
    () ip_comm Port<0.7> httpd_conf_5099default
    "POST"
    "localhost:5099/order?a=1&b=2"
    "/order?a=1&b=2"
    "HTTP/1.1"
    "POST /order?a=1&b=2 HTTP/1.1"
    (#("content-length" "27")
     #("content-type" "application/x-www-form-urlencoded")
     #("accept" "*/*")
     #("user-agent" "curl/7.70.0")
     #("host" "localhost:5099"))
    "param1=value1&param2=value2"
    true))

(defun xformed-req-data ()
  #M(absolute-uri "localhost:5099/order?a=1&b=2"
     body "param1=value1&param2=value2"
     config-db httpd_conf_5099default
     connection true data ()
     headers
     #M("accept" "*/*"
        "content-length" "27"
        "content-type" "application/x-www-form-urlencoded"
        "host" "localhost:5099"
        "user-agent" "curl/7.70.0")
     http-versions "HTTP/1.1"
     init=data #M(peername #(62924 "127.0.0.1")
                  resolve "spacemac"
                  sockname #(5099 "127.0.0.1"))
     method "POST"
     parsed-body
     #M("param1" "value1"
        "param2" "value2")
     path (#"order")
     query #M("a" "1" "b" "2")
     request-line "POST /order?a=1&b=2 HTTP/1.1"
     request-uri "/order?a=1&b=2"
     socket Port<0.7>
     socket-type ip_comm))

(deftest barista-request->map
  (is-equal
    (xformed-req-data)
    (barista-request:->map (test-req-data))))

