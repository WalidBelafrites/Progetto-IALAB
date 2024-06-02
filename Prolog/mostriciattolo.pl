iniziale(pos(1,4)).

finale(pos(4,8)).

:- dynamic(ghiaccio/1).
:- dynamic(martello/1).
:- dynamic(con_martello/1).
:- dynamic(gemma_1/1).
:- dynamic(gemma_2/1).
:- dynamic(gemma_3/1).



muro(pos(2,2)).
muro(pos(1,6)).
muro(pos(2,8)).
muro(pos(3,8)).
muro(pos(4,4)).
muro(pos(4,5)).
muro(pos(5,5)).
muro(pos(6,2)).
muro(pos(7,2)).
muro(pos(7,6)).
muro(pos(8,3)).





ghiaccio(pos(7,7)).
ghiaccio(pos(2,6)).
ghiaccio(pos(2,7)).
ghiaccio(pos(3,7)).
ghiaccio(pos(4,7)).
ghiaccio(pos(5,7)).
ghiaccio(pos(5,8)).



martello(pos(8,2)).

gemma_1(pos(1,7)).
gemma_2(pos(5,4)).
gemma_3(pos(8,8)).

con_martello(0).



applicabile(nord,pos(X,Y)):-
    X > 1,
    XSopra is X - 1,
    con_martello(0),
    \+gemma_1(pos(XSopra,Y)),
    \+gemma_2(pos(XSopra,Y)),
    \+gemma_3(pos(XSopra,Y)),
    \+ghiaccio(pos(XSopra,Y)),
    \+muro(pos(XSopra,Y)).


applicabile(nord, pos(X, Y)) :-
    X > 1,
    XSopra is X - 1,
    con_martello(1),
    ( ghiaccio(pos(XSopra, Y)) -> retract(ghiaccio(pos(XSopra, Y))) ; true ),
    \+gemma_1(pos(XSopra,Y)),
    \+gemma_2(pos(XSopra,Y)),
    \+gemma_3(pos(XSopra,Y)),
    \+ muro(pos(XSopra, Y)).



applicabile(est,pos(X,Y)):-
    Y < 8,
    YDestra is Y + 1,
    con_martello(0),
    \+gemma_1(pos(X,YDestra)),
    \+gemma_2(pos(X,YDestra)),
    \+gemma_3(pos(X,YDestra)),
    \+ghiaccio(pos(X,YDestra)),
    \+muro(pos(X,YDestra)).


applicabile(est,pos(X,Y)):-
    Y < 8,
    YDestra is Y + 1,
    con_martello(1),
    \+gemma_1(pos(X,YDestra)),
    \+gemma_2(pos(X,YDestra)),
    \+gemma_3(pos(X,YDestra)),
    ( ghiaccio(pos(X, YDestra)) -> retract(ghiaccio(pos(X, YDestra))) ; true ),
    \+muro(pos(X,YDestra)).

    
applicabile(sud,pos(X,Y)):-
    X < 8,
    XSotto is X + 1,
    con_martello(0),
    \+gemma_1(pos(XSotto,Y)),
    \+gemma_2(pos(XSotto,Y)),
    \+gemma_3(pos(XSotto,Y)),
    \+ghiaccio(pos(XSotto,Y)),
    \+muro(pos(XSotto,Y)).

applicabile(sud,pos(X,Y)):-
    X < 8,
    XSotto is X + 1,
    con_martello(1),
    \+gemma_1(pos(XSotto,Y)),
    \+gemma_2(pos(XSotto,Y)),
    \+gemma_3(pos(XSotto,Y)),
    ( ghiaccio(pos(XSotto, Y)) -> retract(ghiaccio(pos(XSotto, Y))) ; true ),
    \+muro(pos(XSotto,Y)).



applicabile(ovest,pos(X,Y)):-
    Y > 1,
    YSinistra is Y - 1,
    con_martello(0),
    \+gemma_1(pos(X,YSinistra)),
    \+gemma_2(pos(X,YSinistra)),
    \+gemma_3(pos(X,YSinistra)),
    \+ghiaccio(pos(X,YSinistra)),
    \+muro(pos(X,YSinistra)).


applicabile(ovest,pos(X,Y)):-
    Y > 1,
    YSinistra is Y - 1,
    con_martello(1),
    ( ghiaccio(pos(X, YSinistra)) -> retract(ghiaccio(pos(X, YSinistra))) ; true ),
    \+gemma_1(pos(X,YSinistra)),
    \+gemma_2(pos(X,YSinistra)),
    \+gemma_3(pos(X,YSinistra)),
    \+muro(pos(X,YSinistra)).


trovato_martello(S):-
    martello(S),
    retract(martello(S)),
    retract(con_martello(0)),
    assertz(con_martello(1)).

trasforma(est,pos(X,Y),pos(X,YDestra)):- YDestra is Y + 1, (trovato_martello(pos(X,YDestra)) ; true).

trasforma(ovest,pos(X,Y),pos(X,YSinistra)):- YSinistra is Y - 1, (trovato_martello(pos(X,YSinistra)); true).

trasforma(nord,pos(X,Y),pos(XSopra,Y)):- XSopra is X - 1, (trovato_martello(pos(XSopra,Y)) ; true).

trasforma(sud,pos(X,Y),pos(XSotto,Y)):- XSotto is X + 1, (trovato_martello(pos(XSotto,Y)); true).








ricerca(Cammino):-
    iniziale(S0),
    ric_prof(S0,[],Cammino),!.

ric_prof(S,_,[]):-finale(S),!.


ric_prof(S,Visitati,[Az|SeqAzioni]):-
    applicabile(Az,S),
    trasforma(Az,S,SNuovo),
    \+member(SNuovo,Visitati),
    trasforma_gemme(Az,SNuovo),
    ric_prof(SNuovo,[S|Visitati],SeqAzioni),!.





trasforma_gemme(Az, SNuovo):-
    gemma_1(G1),
    gemma_2(G2),
    gemma_3(G3),

    ( applicabile(Az, G1), G1 \= SNuovo -> trasforma(Az, G1, G1N) ; G1N = G1 ),
    ( applicabile(Az, G2), G2 \= SNuovo -> trasforma(Az, G2, G2N) ; G2N = G2 ),
    ( applicabile(Az, G3), G3 \= SNuovo -> trasforma(Az, G3, G3N) ; G3N = G3 ),

    ( G1N \= G2N, G1N \= G3N -> retract(gemma_1(G1)), assertz(gemma_1(G1N)) ; true ),
    ( G2N \= G1N, G2N \= G3N -> retract(gemma_2(G2)), assertz(gemma_2(G2N)) ; true ),
    ( G3N \= G1N, G3N \= G2N -> retract(gemma_3(G3)), assertz(gemma_3(G3N)) ; true ).
