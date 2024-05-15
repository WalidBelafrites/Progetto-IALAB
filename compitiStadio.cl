squadra(asroma).
squadra(juve).
squadra(sampdoria).
squadra(lazio).
squadra(genoa).
squadra(milan).
squadra(bologna).
squadra(toro).

stadio(asroma,titi).
stadio(juve,alianzstadium).
stadio(sampdoria,toto).
stadio(lazio,titi).
stadio(genoa,toto).
stadio(milan,tutu).
stadio(bologna,nul).
stadio(toro,alianzstadium).

giornata(1..14).

7 {combinazione(A,B) : squadra(B)} 7 :-squadra(A).
4 {match(G,(A,B)) : combinazione(A,B) } 4 :-giornata(G).
1 {stadio_match(G,(A,B), (A, S)) : stadio(A,S)} 1 :- match(G,(A,B)).

:-combinazione(A,B), A == B.
:-match(G,(A,B)),match(J,(C,D)), G != J, (A,B) == (C,D).  % due squadre si possono affrontare solo una volta a casa di una delle due.
:-match(G,(A,B)),match(J,(C,D)), G == J, A == C, B != D.  % una squadra non puo' giocare due partite a casa nella stessa giornata.
:-match(G,(A,B)),match(J,(C,D)), G == J, A != C, B == D.  % una squadra non puo' giocare due partite in trasferta nella stessa giornata.
:-match(G,(A,B)),match(J,(C,D)), G == J, B == C, A != D.  % una squadra non puo' giocare una partita a casa e un'altra in trasferta nella stessa giornata
:-match(G,(A,B)),match(J,(C,D)), G == J, B != C, A == D.  % // // // // // // //
:-match(G,(A,B)),match(J,(C,D)), G == J, B == C, A == D.  % una squadra non puo' giocare una partita a casa e un'altra in trasferta nella stessa giornata (stesso avversario)
:-match(G,(A,B)),match(J,(C,D)), A == D , B == C , G <= 7, J <= 7. 

:-stadio_match((G,(A1,B1)), (A1, S1)), stadio_match((G,(A2,B2)), (A2, S2)), G == J , (A1, B1) != (A2, B2), S1 == S2.


  #show stadio_match/3.
