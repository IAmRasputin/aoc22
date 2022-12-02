(defpackage aoc22/tests/main
  (:use :cl
        :aoc22
        :rove))
(in-package :aoc22/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :aoc22)' in your Lisp.

(deftest test-target-1
  (testing "should (= 1 1) to be true"
    (ok (= 1 1))))
