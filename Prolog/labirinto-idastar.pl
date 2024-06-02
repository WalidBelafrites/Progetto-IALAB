num_righe(20).
num_colonne(20).
iniziale(pos(10,1)).

finale(pos(19,11)).

occupata(pos(1,3)).
occupata(pos(1,4)).
occupata(pos(1,5)).
occupata(pos(1,7)).
occupata(pos(1,17)).
occupata(pos(1,18)).
occupata(pos(1,19)).
occupata(pos(1,20)).
occupata(pos(1,11)).
occupata(pos(2,5)).
occupata(pos(2,10)).
occupata(pos(2,15)).
occupata(pos(2,16)).
occupata(pos(3,1)).
occupata(pos(3,6)).
occupata(pos(3,7)).
occupata(pos(3,9)).
occupata(pos(3,10)).
occupata(pos(3,11)).
occupata(pos(3,12)).
occupata(pos(3,16)).
occupata(pos(3,18)).
occupata(pos(4,4)).
occupata(pos(4,5)).
occupata(pos(4,6)).
occupata(pos(4,7)).
occupata(pos(4,8)).
occupata(pos(4,9)).
occupata(pos(4,13)).
occupata(pos(4,18)).
occupata(pos(5,2)).
occupata(pos(5,7)).
occupata(pos(5,13)).
occupata(pos(5,14)).
occupata(pos(5,15)).
occupata(pos(5,16)).
occupata(pos(5,17)).
occupata(pos(5,18)).
occupata(pos(6,7)).
occupata(pos(6,13)).
occupata(pos(6,14)).
occupata(pos(6,15)).
occupata(pos(6,16)).
occupata(pos(6,17)).
occupata(pos(6,18)).
occupata(pos(7,7)).
occupata(pos(7,9)).
occupata(pos(7,10)).
occupata(pos(7,11)).
occupata(pos(7,12)).
occupata(pos(7,14)).
occupata(pos(7,15)).
occupata(pos(7,16)).
occupata(pos(7,17)).
occupata(pos(7,18)).
occupata(pos(8,1)).
occupata(pos(8,2)).
occupata(pos(8,3)).
occupata(pos(8,5)).
occupata(pos(8,9)).
occupata(pos(8,10)).
occupata(pos(8,11)).
occupata(pos(8,12)).
occupata(pos(8,13)).
occupata(pos(8,14)).
occupata(pos(8,15)).
occupata(pos(8,18)).
occupata(pos(9,4)).
occupata(pos(9,8)).
occupata(pos(9,14)).
occupata(pos(9,15)).
occupata(pos(9,18)).
occupata(pos(9,20)).
occupata(pos(10,2)).
occupata(pos(10,4)).
occupata(pos(10,5)).
occupata(pos(10,6)).
occupata(pos(10,10)).
occupata(pos(10,20)).
occupata(pos(11,1)).
occupata(pos(11,7)).
occupata(pos(11,11)).
occupata(pos(11,17)).
occupata(pos(11,18)).
occupata(pos(11,19)).
occupata(pos(11,20)).
occupata(pos(12,3)).
occupata(pos(12,7)).
occupata(pos(12,9)).
occupata(pos(12,13)).
occupata(pos(13,2)).
occupata(pos(13,6)).
occupata(pos(13,7)).
occupata(pos(13,12)).
occupata(pos(14,1)).
occupata(pos(14,4)).
occupata(pos(14,8)).
occupata(pos(14,14)).
occupata(pos(15,1)).
occupata(pos(15,5)).
occupata(pos(15,11)).
occupata(pos(15,20)).
occupata(pos(15,1)).
occupata(pos(16,12)).
occupata(pos(16,13)).
occupata(pos(16,14)).
occupata(pos(16,15)).
occupata(pos(16,16)).
occupata(pos(16,20)).
occupata(pos(17,1)).
occupata(pos(17,2)).
occupata(pos(17,3)).
occupata(pos(17,4)).
occupata(pos(17,5)).
occupata(pos(17,6)).
occupata(pos(17,7)).
occupata(pos(17,8)).
occupata(pos(17,9)).
occupata(pos(17,17)).
occupata(pos(18,10)).
occupata(pos(18,18)).
occupata(pos(19,10)).
occupata(pos(19,14)).
occupata(pos(19,19)).
occupata(pos(20,10)).
occupata(pos(20,14)).



applicabile(nord,pos(X,Y)):-
    X > 1,
    XSopra is X - 1,
    \+occupata(pos(XSopra,Y)).

applicabile(est,pos(X,Y)):-
    num_colonne(N),
    Y < N,
    YDestra is Y + 1,
    \+occupata(pos(X,YDestra)).



applicabile(sud,pos(X,Y)):-
    num_righe(N),
    X < N,
    XSotto is X + 1,
    \+occupata(pos(XSotto,Y)).

applicabile(ovest,pos(X,Y)):-
    Y > 1,
    YSinistra is Y - 1,
    \+occupata(pos(X,YSinistra)).




trasforma(est,pos(X,Y),pos(X,YDestra)):- YDestra is Y + 1.
trasforma(ovest,pos(X,Y),pos(X,YSinistra)):- YSinistra is Y - 1.
trasforma(nord,pos(X,Y),pos(XSopra,Y)):- XSopra is X - 1.
trasforma(sud,pos(X,Y),pos(XSotto,Y)):- XSotto is X + 1.

:- use_module(library(lists)).

calcolaDistanzaManhattan(pos(A,B),pos(C,D),Ris):-
    Ris is abs(A - C) + abs(B - D).

ricerca(Cammino):-
    iniziale(S0),
    finale(SF),
    calcolaDistanzaManhattan(S0,SF,HS0),
    ricerca_ida(S0,0,[S0],Cammino,HS0).

ricerca_ida(S,_,_,[],Soglia):- finale(S), write(Soglia),!.

ricerca_ida(S, G, Visitati, [Az|SeqAzioni], Soglia) :-
    espandiFiltra(S, G , Visitati, Soglia, ListaFiltrata),
    member((Az, SNuovo, _), ListaFiltrata),
    GN is G + 1,
    ricerca_ida(SNuovo, GN, [SNuovo|Visitati], SeqAzioni, Soglia).


ricerca_ida(S, G, Visitati, Cammino, Soglia) :-
    espandiFiltraSogliaSuperata(S, G, Visitati, Soglia, ListaEspansa),
    findall(F, (member((_, _, F), ListaEspansa)), ListaF),
    min_list(ListaF, NuovaSoglia),
    ricerca_ida(S, G, Visitati, Cammino, NuovaSoglia).


espandiFiltra(S, G, Visitati, Soglia, ListaFiltrata) :-
    findall((Az, SNuovo, F), (
        applicabile(Az, S),
        trasforma(Az, S, SNuovo),
        \+ member(SNuovo, Visitati),
        finale(SF),
        calcolaDistanzaManhattan(SNuovo, SF, H),
        GN is  G + 1,
        F is GN + H,
        F =< Soglia
    ), ListaFiltrata).


espandiFiltraSogliaSuperata(S, G, Visitati, Soglia, ListaFiltrata) :-
    findall((Az, SNuovo, F), (
        applicabile(Az, S),
        trasforma(Az, S, SNuovo),
        \+ member(SNuovo, Visitati),
        finale(SF),
        calcolaDistanzaManhattan(SNuovo, SF, H),
        GN is  G + 1,
        F is GN + H,
        F > Soglia
    ), ListaFiltrata).


