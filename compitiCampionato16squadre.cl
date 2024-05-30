squadra(asroma).
squadra(juventus).
squadra(sampdoria).
squadra(lazio).
squadra(genoa).
squadra(milan).
squadra(bologna).
squadra(toro).

%//////////////////////
squadra(grenobleFoot38)
squadra(psg)
squadra(olympiqueMarseilles)
squadra(olympiqueLyon)
squadra()
squadra()
squadra()
squadra()
%//////////////////////

stadio(asroma,stadio_olimpico).
stadio(juventus,alianzstadium).
stadio(sampdoria,stadio_luigi_ferraris).
stadio(lazio,stadio_olimpico).
stadio(genoa,stadio_luigi_ferraris).
stadio(milan,sanSiro).
stadio(bologna,stadio_renato-dall_ara).
stadio(toro,alianzstadium).

%//////////////////////
stadio(grenobleFoot38,stade_des_alpes)
stadio(psg,parc_des_princes)
stadio(olympique_marseilles,orange_velodrome)
stadio(olympique_lyon,groupama_stadium)
stadio()
stadio()
stadio()
stadio()
%//////////////////////

giornata(1..30).

15 {combinazione(A,B) : squadra(B)} 15 :-squadra(A).
10 {match(G,(A,B)) : combinazione(A,B) } 10 :-giornata(G).
1 {stadio_match(G,(A,B), (A, S)) : stadio(A,S)} 1 :- match(G,(A,B)).

:-combinazione(A,B), A == B.
:-match(G,(A,B)),match(J,(C,D)), G != J, (A,B) == (C,D).  % due squadre si possono affrontare solo una volta a casa di una delle due.
:-match(G,(A,B)),match(J,(C,D)), G == J, A == C, B != D.  % una squadra non puo' giocare due partite a casa nella stessa giornata.
:-match(G,(A,B)),match(J,(C,D)), G == J, A != C, B == D.  % una squadra non puo' giocare due partite in trasferta nella stessa giornata.
:-match(G,(A,B)),match(J,(C,D)), G == J, B == C, A != D.  % una squadra non puo' giocare una partita a casa e un'altra in trasferta nella stessa giornata
:-match(G,(A,B)),match(J,(C,D)), G == J, B != C, A == D.  % // // // // // // //
:-match(G,(A,B)),match(J,(C,D)), G == J, B == C, A == D.  % una squadra non puo' giocare una partita a casa e un'altra in trasferta nella stessa giornata (stesso avversario)
:-match(G,(A,B)),match(J,(C,D)), A == D , B == C , G <= 15, J <= 15. 
<<<<<<< Updated upstream
:-match(G,(A,B)),match(J,(C,D)), A == D , B == C , G <= 15, J <= 15. 
:-match(G,(A,B)),match(J,(C,D)),match(K,(E,F)),A == C, C == E, K = J+1, J = G+1. % una squadra non puo' giocare piu' di due volte consecutivamente a casa
:-match(G,(A,B)),match(J,(C,D)),match(K,(E,F)),B == D, D == F, K = J+1, J = G+1. % una squadra non puo' giocare piu' di due volte consecutivamente i trasferta

stadio_match(G, (A, B), S) :- match(G, (A, B)), stadio(A, S).
:- stadio_match(G, (A, B), S1), stadio_match(G, (C, D), S2), G == J, S1 == S2, (A, B) != (C, D).
=======
:-match(G,(A,B)),match(J,(C,D)), A == D , B == C , G >= 15, J >= 15. 
:-match(G,(A,B)),match(J,(C,D)),match(K,(E,F)),A == C, C == E, K = J+1, J = G+1. % una squadra non puo' giocare piu' di due volte consecutivamente a casa
:-match(G,(A,B)),match(J,(C,D)),match(K,(E,F)),B == D, D == F, K = J+1, J = G+1. % una squadra non puo' giocare piu' di due volte consecutivamente i trasferta
>>>>>>> Stashed changes

  #show stadio_match/3.

