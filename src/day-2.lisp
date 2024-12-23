(in-package :aoc22)

(defvar *day-2-input* (get-input 2))

(defun move-map (input)
  (ecase (char-upcase input)
    ((#\A #\X) :rock)
    ((#\B #\Y) :paper)
    ((#\C #\Z) :scissors)))

(defun score-round (player-1 player-2)
  "returns :player-1, :player-2, or :draw"
  (labels ((play-score (play)
             (ccase play
               (:rock 1)
               (:paper 2)
               (:scissors 3)))
           (matchup (p1 p2)
             (ccase p1
               (:rock (ccase p2
                        (:rock :draw)
                        (:paper :player-2)
                        (:scissors :player-1)))
               (:paper (ccase p2
                        (:rock :player-1)
                        (:paper :draw)
                        (:scissors :player-2)))
               (:scissors (ccase p2
                        (:rock :player-2)
                        (:paper :player-1)
                        (:scissors :draw))))))
    (let* ((outcome (matchup player-1 player-2))
           (score-1 (+ (play-score player-1)
                       (ccase outcome
                         (:player-1 6)
                         (:player-2 0)
                         (:draw 3))))
           (score-2 (+ (play-score player-2)
                       (ccase outcome
                         (:player-1 0)
                         (:player-2 6)
                         (:draw 3)))))
      (list score-1 score-2))))

(defun solve-round (opponent result)
  (ccase play
    (:rock (ccase res
             (:draw :rock)
             (:loss :scissors)
             (:win :paper)))
    (:paper (ccase res
              ))
    (:scissors (ccase res
                 ))))


(defun day-2-1 (input)
  (with-input-from-string (in input)
    (let* ((lines (uiop:slurp-stream-lines in))
           (rounds (mapcar (lambda (line)
                             (score-round (move-map (aref line 0))
                                          (move-map (aref line 2))))
                           lines))
           (score-1 0)
           (score-2 0))
      (dolist (round rounds)
        (incf score-1 (first round))
        (incf score-2 (second round)))
      score-2)))


;; Part 2
