(defsystem "aoc22"
  :version "0.1.0"
  :author "Ryan Gannon"
  :license "MIT"
  :depends-on ("alexandria")
  :components ((:module "src"
                :components
                ((:file "main"))))
  :description ""
  :in-order-to ((test-op (test-op "aoc22/tests"))))

(defsystem "aoc22/tests"
  :author "Ryan Gannon"
  :license "MIT"
  :depends-on ("aoc22"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for aoc22"
  :perform (test-op (op c) (symbol-call :rove :run c)))
