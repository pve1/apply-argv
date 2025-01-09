;;;; apply-argv.asd

(asdf:defsystem #:apply-argv
  :version "0.1"
  :author "Peter von Etter"
  :description "Apply-argv is a library for parsing command line arguments."
  :license "LLGPL"
  :serial t
  :depends-on (:alexandria)
  :components ((:file "package")
               (:file "apply-argv"))
  :in-order-to ((test-op (test-op #:apply-argv/tests))))

(asdf:defsystem #:apply-argv/tests
  :version "0.1"
  :author "Peter von Etter"
  :description "Test system of apply-argv."
  :license "LLGPL"
  :serial t
  :depends-on (:fiveam
               :apply-argv)
  :components ((:file "tests"))
  :perform (test-op (op system)
             (uiop:symbol-call :5am :run! :apply-argv)))
