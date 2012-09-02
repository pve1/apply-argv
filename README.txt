Simple argv parsing.

(parse-argv '("--foo" "bar"
              "--bar=qwe"
              "--qwe"
              "--no-xyz"
              "more" "stuff" "here"))

==> (("more" "stuff" "here") :FOO "bar" :BAR "qwe" :QWE T :XYZ NIL)
