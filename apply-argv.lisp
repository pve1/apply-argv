;;;; apply-argv.lisp

(in-package #:apply-argv)

(defvar *end-keyword-args* (gensym))

(defun test-apply (qwe &key foo bar)
  (list qwe foo bar))

(defun end-args-p (string)
  (equal "--" string))

(defun long-arg-p (string)
  (when-let (a (ignore-errors
                (search "--" string :end2 2)))
    (zerop a)))

(defun short-arg-p (string)
  (when-let (a (and (not (long-arg-p string))
                    (ignore-errors
                     (search "-" string :end2 1))))
    (zerop a)))

(defun no-arg-p (string)
  (when-let (a (and (long-arg-p string)
                    (search "--no-" string)))
    (zerop a)))

(defun get-long-arg (string)
  (if-let ((val (long-arg-equals-value string))
           (arg-ends (search "=" string)))
    (subseq string 2 arg-ends)
    (subseq string 2)))

(defun get-short-arg (string)
  (subseq string 1))

(defun get-no-arg (string)
  (subseq string 5))

(defun argumentp (string)
  (or (long-arg-p string)
      (short-arg-p string)))

(defun get-argument (arg)
  (cond ((short-arg-p arg)
         (get-short-arg arg))

        ((no-arg-p arg)
         (get-no-arg arg))

        ((long-arg-p arg)
         (get-long-arg arg))

        (t (error "Not a command-line argument: ~A." arg))))

(defun long-arg-has-equals-value-p (string)
  (and (long-arg-p string)
       (search "=" string)))

(defun long-arg-equals-value (string)
  (when-let ((a (and (long-arg-p string)
                     (search "=" string))))
    (subseq string (1+ a))))

(defun collect-list-arg (indicator parsed-argv)
  (loop :for (a b) :on parsed-argv :by #'cddr
     :when (eq a indicator)
     :collect b))

(defun keywordify (string)
  (intern (string-upcase string) :keyword))

(defun %parse-argv (argv)
  (when-let (arg (car argv))
    (cond ((end-args-p arg)
           (cons *end-keyword-args* (cdr argv)))

          ((no-arg-p arg)
           (append (list (keywordify (get-argument arg))
                         nil)
                   (%parse-argv (cdr argv))))

          ((when-let (val (long-arg-equals-value arg))
             (append (list (keywordify (get-long-arg arg))
                           val)
                     (%parse-argv (cdr argv)))))

          ((argumentp arg)
           (let ((next-is-argument (when-let (s (second argv))
                                     (argumentp s))))
             (append (list (keywordify (get-argument arg))
                           (if next-is-argument
                               t
                               (second argv)))
                     (if next-is-argument
                         (%parse-argv (cdr argv))
                         (%parse-argv (cddr argv))))))

          (t (cons *end-keyword-args* argv)))))

(defun parse-argv (argv)
  (let* ((result (%parse-argv argv))
         (end-kw (position *end-keyword-args* result)))
    (if end-kw
        (let ((rest (subseq result (1+ end-kw))))
          (if rest
              (cons rest (subseq result 0 end-kw))
              (subseq result 0 end-kw)))
        result)))

(defun parse-argv* (argv)
  (let ((parsed (parse-argv argv)))
    (if (listp (first parsed))
        (append (first parsed) (rest parsed))
        parsed)))

(defun apply-argv (function &rest argv)
  (apply function (parse-argv argv)))
