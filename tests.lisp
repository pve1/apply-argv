(in-package :apply-argv)

(eval-when (:compile-toplevel :load-toplevel :execute)
  (use-package :5am))

(in-suite* :apply-argv)

(test apply-argv-1
  (is (long-arg-p "--foo"))
  (is (not (long-arg-p "-foo")))
  (is (short-arg-p "-foo"))
  (is (not (short-arg-p "--foo")))
  (is (not (short-arg-p "foo")))
  (is (not (long-arg-p "foo")))
  (is (long-arg-has-equals-value-p "--foo=bar"))
  (is (not (long-arg-has-equals-value-p "--foo")))
  (is (string= "bar" (long-arg-equals-value "--foo=bar")))
  (is (string= "" (long-arg-equals-value "--foo=")))
  (is (null (long-arg-equals-value "--foo")))

  (is (no-arg-p "--no-foo"))
  (is (not (no-arg-p "--foo")))
  (is (string= "foo" (get-no-arg "--no-foo")))

  (is (string= "foo" (get-no-arg "--no-foo")))
  (is (string= "foo" (get-long-arg "--foo")))
  (is (string= "foo" (get-long-arg "--foo=bar")))

  (is (string= "foo" (get-argument "--no-foo")))
  (is (string= "foo" (get-argument "--foo")))
  (is (string= "foo" (get-argument "-foo")))
  (is (string= "foo" (get-argument "--foo=bar")))

  (is (equal '(("--aaa") :FOO "bar")
             (parse-argv '("--foo=bar" "--" "--aaa"))))

  (is (equal '(("ASDASD") :FOO "bar" :AAA T :QWE T :BAR "asda")
             (parse-argv '("--foo=bar"
                           "-aaa"
                           "--qwe"
                           "--bar=asda"
                           "--" "ASDASD"))))
  (is (equal '(:foo "bar"
               :bar "qwe"
               :qwe t
               :xyz nil)
             (parse-argv '("--foo" "bar"
                           "--bar=qwe"
                           "--qwe"
                           "--no-xyz"))))

  (is (null (parse-argv '("--"))))

  (is (equal '(("foo")) (parse-argv '("--" "foo"))))

  (is (equal '(:foo "bar" :bar "qwe")
             (parse-argv '("--foo" "bar" "--bar" "qwe"))))

  (is (equal '(("qwe") :foo "bar")
             (parse-argv '("--foo" "bar" "qwe"))))

  (is (equal '(("qwe") "foo" "bar")
             (apply-argv 'test-apply
                         "--foo" "foo"
                         "--bar=bar"
                         "qwe")))

  (is (equal '(("qwe") "foo" "bar")
             (apply-argv 'test-apply
                         "--foo" "foo"
                         "--bar" "bar"
                         "qwe"))))
