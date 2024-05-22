;  ---------------------------------------------
;  --- Definizione del modulo e dei template ---
;  ---------------------------------------------
(defmodule AGENT (import MAIN ?ALL) (import GAME ?ALL) (export ?ALL))

(defrule human-player
  (status (step ?s) (mode human))
  =>
  (printout t "Your guess at step " ?s crlf)
  (bind $?input (readline))
  (assert (guess (step ?s) (g  (explode$ $?input)) ))
  (pop-focus)
 )
 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule computer-player
  (status (step ?s) (mode computer))
  =>
  (focus MAIN)
  (assert (combination (code (create$ blue green red yellow orange white black purple))))
  (focus COMBINATION_GENERATOR)
)


(defrule generate-all-possibilities
    (status (step 0) (mode computer))
    =>
    (assert (combination (code (create$ blue green red yellow orange white black purple))))
    (focus COMBINATION_GENERATOR)
)

(defrule submit-guess
    (status (step ?s) (mode computer))
    (combination (code $?code))
    =>
    (assert (guess (step ?s) (g $?code)))
    (focus GAME)
)
(defrule reduce-search-space
    (status (step ?s) (mode computer))
    (answer (step ?s) (right-placed ?rp) (miss-placed ?mp))
    (combination (code $?code))
    =>
    ;; code to reduce search space based on feedback
    (focus MAIN)
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;