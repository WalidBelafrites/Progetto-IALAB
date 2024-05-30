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


;Generazione di una lista di colori casuale a partire di una lista di colori possibile
(deffunction random-color (?already-chosen ?available-colors)
  (bind ?colors (create$ ?available-colors))
  (bind ?available-colors (create$))
  (foreach ?color ?colors
    (if (not (member$ ?color ?already-chosen)) then
      (bind ?available-colors (create$ ?available-colors ?color))
    )
  )
  (return (nth$ (random 1 (length$ ?available-colors)) ?available-colors))
)

;Generazione del nuovo guess con l'utilizazione dei colori "right-placed"
(deffunction generate-new-guess (?prev-guess ?right-placed ?colortouse)
  (bind ?guess (create$))
  (bind ?used-colors (create$))

  ;Generazione della prima colore del "guess"
  (if (> ?right-placed 0) then
    (bind ?guess (create$ (nth$ 1 ?prev-guess)))
    (bind ?used-colors (create$ (nth$ 1 ?prev-guess)))
  else
    (bind ?new-color (random-color ?used-colors ?colortouse))
    (bind ?guess (create$ ?new-color))
    (bind ?used-colors (create$ ?new-color)))
  
  ;Generazione della seconda colore del "guess"
  (if (> ?right-placed 1) then
    (bind ?guess (create$ ?guess (nth$ 2 ?prev-guess)))
    (bind ?used-colors (create$ ?used-colors (nth$ 2 ?prev-guess)))
  else
    (bind ?new-color (random-color ?used-colors ?colortouse))
    (bind ?guess (create$ ?guess ?new-color))
    (bind ?used-colors (create$ ?used-colors ?new-color)))

  ;Generazione della terza colore del "guess"
  (if (> ?right-placed 2) then
    (bind ?guess (create$ ?guess (nth$ 3 ?prev-guess)))
    (bind ?used-colors (create$ ?used-colors (nth$ 3 ?prev-guess)))
  else
    (bind ?new-color (random-color ?used-colors ?colortouse))
    (bind ?guess (create$ ?guess ?new-color))
    (bind ?used-colors (create$ ?used-colors ?new-color)))

  ;Generazione dell'ultima colore del "guess"
  (if (> ?right-placed 3) then
    (bind ?guess (create$ ?guess (nth$ 4 ?prev-guess)))
    (bind ?used-colors (create$ ?used-colors (nth$ 4 ?prev-guess)))
  else
    (bind ?new-color (random-color ?used-colors ?colortouse))
    (bind ?guess (create$ ?guess ?new-color))
    (bind ?used-colors (create$ ?used-colors ?new-color)))

  (return ?guess)
)

; Verificazione dei due casi del guess
(deffunction generate-guess (?prev-guess ?right-placed ?miss-placed)
(bind ?basic-colors (create$ blue green red yellow orange white black purple))
  (bind ?total-correct (+ ?right-placed ?miss-placed))
  (bind ?guess (if (= ?total-correct 4)
                  ;Ce ne già tutti i colori nel "prev-guess" dobbiamo solo verificare l'ordine
                  then (generate-new-guess (create$ ?prev-guess) ?right-placed ?prev-guess )
                  ;Caso di base
                  else (generate-new-guess (create$ ?prev-guess) ?right-placed ?basic-colors)))
  (return ?guess)
)

; Defrule del computer dopo il primo passo
(defrule computer-player
  (status (step ?s&:(> ?s 1)) (mode computer))
  (guess (step ?prev-step&:(= ?prev-step (- ?s 1))) (g $?prev-guess))
  (answer (step ?prev-step) (right-placed ?right) (miss-placed ?misplaced))
  =>
  (bind ?guess (generate-guess (create$ ?prev-guess) ?right ?misplaced))
  (printout t "Computer's guess at step " ?s ":" crlf)
  (foreach ?color ?guess
    (printout t ?color crlf))
  (assert (guess (step ?s) (g ?guess)))
  (pop-focus)
)


; Defrule del computer al primo passo
(defrule computer-player
  (status (step ?s&:(> ?s 1)) (mode computer))
  (guess (step ?prev-step&:(= ?prev-step (- ?s 1))) (g $?prev-guess))
  (answer (step ?prev-step) (right-placed ?right) (miss-placed ?misplaced))
  =>
  (bind ?guess (generate-guess (create$ ?prev-guess) ?right ?misplaced))
  (printout t "Computer's guess at step " ?s ":" crlf)
  (foreach ?color ?guess
    (printout t ?color crlf))
  (assert (guess (step ?s) (g ?guess)))
  (pop-focus)
)


; Règle pour le joueur ordinateur au premier tour
(defrule first-computer-player
  (status (step 1) (mode computer))
  =>
  (bind ?basic-colors (create$ blue green red yellow orange white black purple))
  (bind ?guess (create$))
  (bind ?new-color (random-color ?guess ?basic-colors))
  (bind ?guess (create$ ?guess ?new-color))
  (bind ?new-color (random-color ?guess ?basic-colors))
  (bind ?guess (create$ ?guess ?new-color))
  (bind ?new-color (random-color ?guess ?basic-colors))
  (bind ?guess (create$ ?guess ?new-color))
  (bind ?new-color (random-color ?guess ?basic-colors))
  (bind ?guess (create$ ?guess ?new-color))
  (printout t "Computer's first guess:" crlf)
  (foreach ?color ?guess
    (printout t ?color crlf))
  (assert (guess (step 1) (g ?guess)))
  (pop-focus)
)





; Règle pour le joueur ordinateur au premier tour
;(defrule first-computer-player-strat-2
;  (status (step 1) (mode computer2))
;  =>
;  (bind ?basic-colors (create$ blue green red yellow orange white black purple))
;  (bind ?guess (create$))
;  (bind ?new-color (random-color ?guess ?basic-colors))
;  (bind ?guess (create$ ?guess ?new-color))
;  (bind ?new-color (random-color ?guess ?basic-colors))
;  (bind ?guess (create$ ?guess ?new-color))
;  (bind ?new-color (random-color ?guess ?basic-colors))
;  (bind ?guess (create$ ?guess ?new-color))
;  (bind ?new-color (random-color ?guess ?basic-colors))
;  (bind ?guess (create$ ?guess ?new-color))
;  (printout t "Computer's first guess with strategy 2:" crlf)
;  (foreach ?color ?guess
;    (printout t ?color crlf))
;  (assert (guess (step 1) (g ?guess)))
;  (pop-focus)
;)