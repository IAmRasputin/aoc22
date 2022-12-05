(defpackage aoc22
  (:use :cl)
  (:local-nicknames (:html :plump)
                    (:alx :alexandria)
                    (:http :dexador))
  (:import-from :uiop :getenv))


(in-package :aoc22)
(.env:load-env (asdf:system-relative-pathname :aoc22 ".env"))
