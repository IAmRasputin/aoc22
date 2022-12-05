(in-package :aoc22)

(defun group-elves (input)
  "Where INPUT is a list of integers (or nil for line breaks)"
  (let ( groups
         current )
    (dolist (calories input)
      (if (null calories)
          (progn
            (push (reverse current) groups)
            (setf current nil))
          (push calories current)))
    (when current
      (push (reverse current) groups))
    (reverse groups)))

(defun day-1-1 (input)
  (let ((values (mapcar (lambda (val)
                          (if (equal val "")
                              nil
                              (parse-integer val)))
                        (with-input-from-string (s input)
                          (uiop:slurp-stream-lines s)))))
    (apply #'max (mapcar (lambda (elf)
                           (apply #'+ elf))
                         values))))
