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
 
;  ---------------------------------------------
;  ---------------------------------------------

;(deffunction random-color (?already-chosen)
;  (bind ?colors (create$ blue green red yellow orange white black purple))
;  (bind ?available-colors (create$))
;  (foreach ?color ?colors
;    (if (not (member$ ?color ?already-chosen)) then
;      (bind ?available-colors (create$ ?available-colors ?color))
;    )
;  )
;  (return (nth$ (random 1 (length$ ?available-colors)) ?available-colors))
;)

;(deffunction generate-random-guess ()
;  (bind ?first (random-color (create$)))
;  (bind ?second (random-color (create$ ?first)))
;  (bind ?third (random-color (create$ ?first ?second)))
;  (bind ?fourth (random-color (create$ ?first ?second ?third)))
;  (return (create$ ?first ?second ?third ?fourth))
;)

;(defrule computer-player
;  (status (step ?s) (mode computer))
;  =>
;  (bind ?guess (generate-random-guess))
;  (printout t "Computer's guess at step " ?s ":" crlf)
;  (foreach ?color ?guess
;    (printout t ?color crlf))
;  (assert (guess (step ?s) (g ?guess)))
;  (pop-focus)
;)


; Fonction pour générer une couleur aléatoire non encore choisie
(deffunction random-color (?already-chosen)
  (bind ?colors (create$ blue green red yellow orange white black purple))
  (bind ?available-colors (create$))
  (foreach ?color ?colors
    (if (not (member$ ?color ?already-chosen)) then
      (bind ?available-colors (create$ ?available-colors ?color))
    )
  )
  (return (nth$ (random 1 (length$ ?available-colors)) ?available-colors))
)

; Fonction pour générer une supposition aléatoire avec des couleurs différentes
(deffunction generate-random-guess (?prev-guess ?right-placed)
  (bind ?guess (create$))
  (bind ?used-colors (create$))

  ; Générer les couleurs correctement placées
  (if (> ?right-placed 0) then
    (bind ?guess (create$ (nth$ 1 ?prev-guess)))
    (bind ?used-colors (create$ (nth$ 1 ?prev-guess)))
  else
    (bind ?new-color (random-color ?used-colors))
    (bind ?guess (create$ ?new-color))
    (bind ?used-colors (create$ ?new-color)))
  
  (if (> ?right-placed 1) then
    (bind ?guess (create$ ?guess (nth$ 2 ?prev-guess)))
    (bind ?used-colors (create$ ?used-colors (nth$ 2 ?prev-guess)))
  else
    (bind ?new-color (random-color ?used-colors))
    (bind ?guess (create$ ?guess ?new-color))
    (bind ?used-colors (create$ ?used-colors ?new-color)))

  (if (> ?right-placed 2) then
    (bind ?guess (create$ ?guess (nth$ 3 ?prev-guess)))
    (bind ?used-colors (create$ ?used-colors (nth$ 3 ?prev-guess)))
  else
    (bind ?new-color (random-color ?used-colors))
    (bind ?guess (create$ ?guess ?new-color))
    (bind ?used-colors (create$ ?used-colors ?new-color)))

  (if (> ?right-placed 3) then
    (bind ?guess (create$ ?guess (nth$ 4 ?prev-guess)))
    (bind ?used-colors (create$ ?used-colors (nth$ 4 ?prev-guess)))
  else
    (bind ?new-color (random-color ?used-colors))
    (bind ?guess (create$ ?guess ?new-color))
    (bind ?used-colors (create$ ?used-colors ?new-color)))

  ; Retourner la supposition avec des couleurs différentes
  (return ?guess)
)

; Règle pour le joueur informatique (après le premier tour)
(defrule computer-player
  (status (step ?s&:(> ?s 1)) (mode computer))
  (guess (step ?prev-step&:(= ?prev-step (- ?s 1))) (g $?prev-guess))
  (answer (step ?prev-step) (right-placed ?right) (miss-placed ?misplaced))
  =>
  (bind ?guess (generate-random-guess (create$ ?prev-guess) ?right))
  (printout t "Computer's guess at step " ?s ":" crlf)
  (foreach ?color ?guess
    (printout t ?color crlf))
  (assert (guess (step ?s) (g ?guess)))
  (pop-focus)
)

; Règle initiale pour le premier pas sans feedback
(defrule first-computer-player
  (status (step 1) (mode computer))
  =>
  (bind ?guess (create$))
  (bind ?new-color (random-color ?guess))
  (bind ?guess (create$ ?guess ?new-color))
  (bind ?new-color (random-color ?guess))
  (bind ?guess (create$ ?guess ?new-color))
  (bind ?new-color (random-color ?guess))
  (bind ?guess (create$ ?guess ?new-color))
  (bind ?new-color (random-color ?guess))
  (bind ?guess (create$ ?guess ?new-color))
  (printout t "Computer's first guess:" crlf)
  (foreach ?color ?guess
    (printout t ?color crlf))
  (assert (guess (step 1) (g ?guess)))
  (pop-focus)
)