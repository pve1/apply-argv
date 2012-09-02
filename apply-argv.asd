;;;; apply-argv.asd

(asdf:defsystem #:apply-argv
  :serial t
  :depends-on (:alexandria)

  :components ((:file "package")
               (:file "apply-argv")))

(asdf:defsystem #:apply-argv-tests
  :serial t
  :depends-on (:fiveam
               :apply-argv)
  :components ((:file "tests")))

(defmethod asdf:perform ((op test-op)
                         (c (eql (find-system :apply-argv))))
  (require :apply-argv-tests)
  (funcall (read-from-string "5AM:RUN!") :apply-argv))