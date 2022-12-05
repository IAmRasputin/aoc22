(in-package :aoc22)

(defvar *session-token* (getenv "SESSION_TOKEN"))
(defvar *prompt-width* 80)
(defvar *15-mins-in-seconds* 900)

(defparameter *default-headers* `(("User-Agent" . "github.com/IAmRasputin/aoc22 by ryanmgannon@gmail.com")
                                  ("Cookie" . ,(format nil "session=~a;" *session-token*))))

(let (last-request-time
      (cookie-jar (cl-cookie:make-cookie-jar :cookies (list (cl-cookie:make-cookie :name "session"
                                                                                   :value *session-token*)))))
  (defun http-get (day type)
    (when (and last-request-time (> *15-mins-in-seconds* (- (get-universal-time) last-request-time)))
      (format *error-output* "HEY!  STOP HAMMERING THE SERVERS!!~&"))

    (setf last-request-time (get-universal-time))
    (http:get (format nil
                      (ecase type
                        (:input "https://adventofcode.com/2022/day/~d/input")
                        (:prompt "https://adventofcode.com/2022/day/~d"))
                      day)
              :cookie-jar cookie-jar
              :headers *default-headers*)))

(defun html-node-to-text (root-node)
  "Within reason."
  (with-output-to-string (out)
    (labels ((translate-and-write-node (node)
               (etypecase node
                 (html:element (format out "~a~%" (bobbin:wrap (html:text node) *prompt-width*)))
                 (html:text-node (format out "~%")))))
      (loop for child being the elements of (html:children root-node) do
        (translate-and-write-node child)))))

;; Caching, my old nemesis
(let ((input-file-cache (make-hash-table))
      (prompt-cache (make-hash-table)))
  (labels ((download-input-file (day)
             (http-get day :input))
           (download-prompt (day)
             (let* ((body (http-get day :prompt))
                    (dom-tree (html:parse body))
                    (article-body (car (html:get-elements-by-tag-name dom-tree "article"))))
               article-body)))
    (defun input-file-cache () input-file-cache)
    (defun prompt-cache () input-file-cache)

    (defun print-propmt (day)
      (let ((prompt (get-aoc-file day :prompt)))
        (format t "~a~%" (html-node-to-text prompt))))

    (defun get-aoc-file (day &optional (type :input) force-prompt-update)
      (let ((cur (gethash day
                          (ccase type
                            (:input input-file-cache)
                            (:prompt prompt-cache)))))
        (when (and (eq type :prompt) force-prompt-update)
          (setf cur nil))

        (or cur
            (ccase type
              (:input (let ((new (download-input-file day)))
                        (setf (gethash day input-file-cache) new)
                        new))
              (:prompt (let ((new (download-prompt day)))
                         (setf (gethash day prompt-cache) new)
                         new))))))))

(defun get-input (day)
  "Returns the input file for day DAY as a string"
  (get-aoc-file day))

(defun get-prompt (day &key force as-node)
  "Returns the prompt for day DAY as a string.
NOTE: The prompt for the day changes after you answer the first question.
You will need to call this again, passing :force t to avoid just getting the
cached version."
  (let ((p (get-aoc-file day :prompt force)))
    (if as-node
        p
        (html-node-to-text p))))

;; Fancy-shamcy input readers, relative to the asd
;; do I still need this?  Wrote the above functions after I wrote this one
(defmacro with-open-input-file ((stream day problem-number &rest options &key (input-type :input) &allow-other-keys) &body body)
  (let* ((filespec (format nil
                           (ecase input-type
                             (:input "inputs/day~d-~d.txt")
                             (:test "test-inputs/day-~d-~d.txt")
                             (:prompt "prompts/day-~d-~d.txt"))
                           day
                           problem-number))
         (relative-filespec (asdf:system-relative-pathname :aoc22 filespec)))
  `(with-open-file (,stream ,relative-filespec ,@options)
     ,@body)))

