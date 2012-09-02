;;;; package.lisp

(defpackage #:apply-argv
  (:use :cl :alexandria)
  (:export #:apply-argv
           #:parse-argv
           #:parse-argv*))
