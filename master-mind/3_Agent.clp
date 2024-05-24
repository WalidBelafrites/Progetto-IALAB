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


;  -------------NO MORE USE---------------------
;  ---------------------------------------------
; Fonction pour générer une couleur aléatoire
;(deffunction random-color ()
;  (bind ?colors (create$ red blue green yellow orange purple))
;  (return (nth$ (random 1 (length$ ?colors)) ?colors))
;)
;  ---------------------------------------------
;  ---------------------------------------------


; Fonction pour générer une couleur aléatoire non encore choisie
(deffunction random-color (?already-chosen)
  (bind ?colors (create$ red blue green yellow orange purple))
  (bind ?available-colors (create$))
  (foreach ?color ?colors
    (if (not (member$ ?color ?already-chosen)) then
      (bind ?available-colors (create$ ?available-colors ?color))
    )
  )
  (return (nth$ (random 1 (length$ ?available-colors)) ?available-colors))
)



; Fonction pour générer une supposition aléatoire
;(deffunction generate-random-guess ()
;  (create$ (random-color) (random-color) (random-color) (random-color))
;)

; Fonction pour générer une supposition aléatoire avec des couleurs différentes
(deffunction generate-random-guess ()
  (bind ?first (random-color (create$)))
  (bind ?second (random-color (create$ ?first)))
  (bind ?third (random-color (create$ ?first ?second)))
  (bind ?fourth (random-color (create$ ?first ?second ?third)))
  (return (create$ ?first ?second ?third ?fourth))
)



(defrule computer-player
  (status (step ?s) (mode computer))
  =>
  (bind ?guess (generate-random-guess))
  (printout t "Computer's guess at step " ?s ":" crlf)
  (foreach ?color ?guess
    (printout t ?color crlf))
  (assert (guess (step ?s) (g ?guess)))
  (pop-focus)
)



;;(defrule computer-player
;;  (status (step ?s) (mode computer))
;;  =>
;;  (printout t "Computer's guess at step " ?s crlf)
  ;; Implémentez ici votre algorithme de décision pour générer une supposition
  ;;(bind $?input (readline))
;;  (bind ?guess (generate-random-guess))
  ;;(bind ?guess (generate-computer-guess ?s))
  
  ;;(assert (guess (step ?s) (g  (explode$ $?input)) ))
;;  (assert (guess (step ?s) (g ?guess)))
  ;;(assert (guess (step ?s) (g ?guess)))
;;  (pop-focus)
;; )
