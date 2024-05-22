;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmodule COMBINATION_GENERATOR (import MAIN ?ALL))

(deftemplate combination
    (multislot code (allowed-values blue green red yellow orange white black purple) (cardinality 4 4))
)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;