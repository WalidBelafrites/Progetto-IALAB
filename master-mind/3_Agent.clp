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
(deffunction random-color (?already-chosen)
  (bind ?available-colors (create$ blue green red yellow orange white black purple))
  (bind ?colors (create$ ?available-colors))
  (bind ?available-colors (create$))
  (foreach ?color ?colors
    (if (not (member$ ?color ?already-chosen)) then
      (bind ?available-colors (create$ ?available-colors ?color))
    )
  )
  (return (nth$ (random 1 (length$ ?available-colors)) ?available-colors))
)

(deffunction guess-final (?prev-guess ?right-placed)
  (bind ?guess (create$))
  (if (= ?right-placed 0) then
    (bind ?guess (create$ (nth$ 4 ?prev-guess)))
    (bind ?guess (create$ ?guess (nth$ 1 ?prev-guess)))
    (bind ?guess (create$ ?guess (nth$ 2 ?prev-guess)))
    (bind ?guess (create$ ?guess (nth$ 3 ?prev-guess)))
  else
    (if (= ?right-placed 1) then
      (bind ?guess (create$ (nth$ 1 ?prev-guess)))
      (bind ?guess (create$ ?guess (nth$ 4 ?prev-guess)))
      (bind ?guess (create$ ?guess (nth$ 2 ?prev-guess)))
      (bind ?guess (create$ ?guess (nth$ 3 ?prev-guess)))
    else
      (bind ?guess (create$ (nth$ 1 ?prev-guess)))
      (bind ?guess (create$ ?guess (nth$ 2 ?prev-guess)))
      (bind ?guess (create$ ?guess (nth$ 4 ?prev-guess)))
      (bind ?guess (create$ ?guess (nth$ 3 ?prev-guess)))
    )
  )
)


;STRAT 1 CON SOLO L'USO DEL RIGHT PLACED
;--------------------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------------------

;Generazione del nuovo guess con l'utilizazione dei colori "right-placed"
(deffunction guess-right-placed (?prev-guess ?right-placed )
  (bind ?guess (create$))
  (bind ?used-colors (create$))

  ;Generazione della prima colore del "guess"
  (if (> ?right-placed 0) then
    (bind ?guess (create$ (nth$ 1 ?prev-guess)))
    (bind ?used-colors (create$ (nth$ 1 ?prev-guess)))
  else
    (bind ?new-color (random-color ?used-colors ))
    (bind ?guess (create$ ?new-color))
    (bind ?used-colors (create$ ?new-color)))
  
  ;Generazione della seconda colore del "guess"
  (if (> ?right-placed 1) then
    (bind ?guess (create$ ?guess (nth$ 2 ?prev-guess)))
    (bind ?used-colors (create$ ?used-colors (nth$ 2 ?prev-guess)))
  else
    (bind ?new-color (random-color ?used-colors ))
    (bind ?guess (create$ ?guess ?new-color))
    (bind ?used-colors (create$ ?used-colors ?new-color)))

  ;Generazione della terza colore del "guess"
  (if (> ?right-placed 2) then
    (bind ?guess (create$ ?guess (nth$ 3 ?prev-guess)))
    (bind ?used-colors (create$ ?used-colors (nth$ 3 ?prev-guess)))
  else
    (bind ?new-color (random-color ?used-colors ))
    (bind ?guess (create$ ?guess ?new-color))
    (bind ?used-colors (create$ ?used-colors ?new-color)))

  (bind ?new-color (random-color ?used-colors ))
  (bind ?guess (create$ ?guess ?new-color))
  (bind ?used-colors (create$ ?used-colors ?new-color));)

  (return ?guess)
)

;STRAT 2 CON L'USO DEI COLORI (RIGHT PLACED + MISS PLACED)
;--------------------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------------------

; Generazione della risposta con colori differenti
(deffunction guess-color-ver (?prev-guess ?total-correct)
  ;Il guess
  (bind ?guess (create$))
  ;colori già utilisate nel guess
  (bind ?used-colors (create$))

  ; Generazione delle colori con l'uso del "miss placed"
  (if (> ?total-correct 0) then
    (bind ?guess (create$ (nth$ 1 ?prev-guess)))
    (bind ?used-colors (create$ (nth$ 1 ?prev-guess)))
  else
    (bind ?new-color (random-color ?used-colors))
    (bind ?guess (create$ ?new-color))
    (bind ?used-colors (create$ ?new-color)))
  
  (if (> ?total-correct 1) then
    (bind ?guess (create$ ?guess (nth$ 2 ?prev-guess)))
    (bind ?used-colors (create$ ?used-colors (nth$ 2 ?prev-guess)))
  else
    (bind ?new-color (random-color ?used-colors))
    (bind ?guess (create$ ?guess ?new-color))
    (bind ?used-colors (create$ ?used-colors ?new-color)))

  (if (> ?total-correct 2) then
    (bind ?guess (create$ ?guess (nth$ 3 ?prev-guess)))
    (bind ?used-colors (create$ ?used-colors (nth$ 3 ?prev-guess)))
  else
    (bind ?new-color (random-color ?used-colors))
    (bind ?guess (create$ ?guess ?new-color))
    (bind ?used-colors (create$ ?used-colors ?new-color)))

  ;ultima colore
  (bind ?new-color (random-color ?used-colors))
  (bind ?guess (create$ ?guess ?new-color))

  (return ?guess)
)
;--------------------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------------------

; Verificazione dei due casi del guess
(deffunction generate-guess (?prev-guess ?right-placed ?miss-placed)
  (bind ?total-correct (+ ?right-placed ?miss-placed))
  (bind ?guess (if (= ?total-correct 4)
                  ;Ce ne già tutti i colori nel "prev-guess" dobbiamo solo verificare l'ordine
                  then (guess-final (create$ ?prev-guess) ?right-placed)
                  ;Caso di base
                  ;else (guess-right-placed (create$ ?prev-guess) ?right-placed)))
                  else (guess-color-ver (create$ ?prev-guess) ?total-correct)))
  (return ?guess)
)

;--------------------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------------------

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
(defrule first-computer-player
  (status (step 1) (mode computer))
  =>
  (bind ?guess (create$))
  (bind ?new-color (random-color ?guess ))
  (bind ?guess (create$ ?guess ?new-color))
  (bind ?new-color (random-color ?guess ))
  (bind ?guess (create$ ?guess ?new-color))
  (bind ?new-color (random-color ?guess ))
  (bind ?guess (create$ ?guess ?new-color))
  (bind ?new-color (random-color ?guess ))
  (bind ?guess (create$ ?guess ?new-color))
  (printout t "Computer's first guess:" crlf)
  (foreach ?color ?guess
    (printout t ?color crlf))
  (assert (guess (step 1) (g ?guess)))
  (pop-focus)
)

;--------------------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------------------