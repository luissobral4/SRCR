%Declaracoes iniciaias

:- set_prolog_flag(discontiguous_warnings,off).
:- set_prolog_flag(single_var_warnings,off).

%Definicoes iniciais
:- op( 900,xfy,'::' ).
:- use_module(library(lists)).

:- include('pontos_Recolha.pl').
:- include('arco.pl').

%% Estado Inicial e Estado Final
inicial('R da Boavista').
final('Tv Corpo Santo').

%% ---------- Depth First ---------------------------------------------------

%% Com distância
ppCustoTodasSolucoes :- findall((S,C),(resolve_pp(S,C)),L),escreve(L).

resolve_pp([Nodo|Caminho],Custo) :-
	inicial(Nodo),
    profundidadeprimeiro(Nodo, [Nodo], Caminho, Custo).

profundidadeprimeiro(Nodo,_,[],0) :- final(Nodo).

profundidadeprimeiro(Nodo,Historico,[ProxNodo|Caminho],Custo) :-
    arco(Nodo,ProxNodo,Dist),
    nao(membro(ProxNodo,Historico)),
    profundidadeprimeiro(ProxNodo,[ProxNodo|Historico],Caminho,Custo2),
    Custo is Dist + Custo2.

%% Caminho mais rápido
melhorCaminhoDF(R):- findall((S,C),(resolve_pp(S,C)),L),minimo(L,R).


%% Número de arcos -----------------------------------------------------------
ppArcosTodasSolucoes :- findall((S,C),(resolve_ppArcos(S,C)),L), escreve(L).

resolve_ppArcos([Nodo|Caminho],Arcos) :-
	inicial(Nodo),
    profundidadeprimeiroArcos(Nodo, [Nodo], Caminho, Arcos).

profundidadeprimeiroArcos(Nodo,_,[],0) :- final(Nodo).

profundidadeprimeiroArcos(Nodo,Historico,[ProxNodo|Caminho],Arcos) :-
    arco(Nodo,ProxNodo,Dist),
    nao(membro(ProxNodo,Historico)),
    profundidadeprimeiroArcos(ProxNodo,[ProxNodo|Historico],Caminho,Arcos2),
    Arcos is 1 + Arcos2.

 %% Caminho mais curto
caminhoCurtoDF(R):- findall((S,C),(resolve_ppArcos(S,C)),L),minimo(L,R).

%% Produtividade -------------------------------------------------------------

ppTodasSolucoes :- findall((S,A,C,P),(resolve_ppProd(S,A,C,P)),L),escreve(L).

resolve_ppProd([Nodo|Caminho],Arcos,Custo,Prod) :-
	inicial(Nodo),
    profundidadeprimeiroProd(Nodo, [Nodo], Caminho, Arcos, Custo),
    Prod is Custo/Arcos.

profundidadeprimeiroProd(Nodo,_,[],0,0) :- final(Nodo).

profundidadeprimeiroProd(Nodo,Historico,[ProxNodo|Caminho],Arcos, Custo) :-
    arco(Nodo,ProxNodo,Dist),
    nao(membro(ProxNodo,Historico)),
    profundidadeprimeiroProd(ProxNodo,[ProxNodo|Historico],Caminho,Arcos2, Custo2),
    Arcos is 1 + Arcos2,
    Custo is Dist + Custo2.

%% Caminho mais eficiente
caminhoEficienteDF(R):- findall((S,P),(resolve_ppProd(S,A,C,P)),L),minimo(L,R).

%% Tipos de Resíduos --------------------------------------------------------

ppCustoTiposTodasSolucoes(T) :- findall((S,C),(resolve_ppTipo(S,C,T)),L),escreve(L).

resolve_ppTipo([Nodo|Caminho],Custo,Tipo) :-
	inicial(Nodo),
    profundidadeprimeiroTipo(Nodo, [Nodo], Caminho, Custo,Tipo).

profundidadeprimeiroTipo(Nodo,_,[],0,_) :- final(Nodo).

profundidadeprimeiroTipo(Nodo,Historico,[ProxNodo|Caminho],Custo,Tipo) :-
	ponto_recolha(_,_,Nodo,Tipo,_),
    arco(Nodo,ProxNodo,Dist),
    nao(membro(ProxNodo,Historico)),
    profundidadeprimeiroTipo(ProxNodo,[ProxNodo|Historico],Caminho,Custo2,Tipo),
    Custo is Dist + Custo2.

%% Tipos de Resíduos --------------------------------------------------------


ppCustoTiposTodasSolucoes2(T) :- findall((S,C),(resolve_ppTipo2(S,C,T)),L),escreve(L).

resolve_ppTipo2([Nodo|Caminho],Arcos,Tipo) :-
	inicial(Nodo),
    profundidadeprimeiroTipo2(Nodo, [Nodo], Caminho, Arcos,Tipo).

profundidadeprimeiroTipo2(Nodo,_,[],1,_) :- final(Nodo).

profundidadeprimeiroTipo2(Nodo,Historico,[ProxNodo|Caminho],Arcos,Tipo) :-
	ponto_recolha(_,_,Nodo,Tipo,_),
    arco(Nodo,ProxNodo,Dist),
    nao(membro(ProxNodo,Historico)),
    profundidadeprimeiroTipo2(ProxNodo,[ProxNodo|Historico],Caminho,Arcos2,Tipo),
    Arcos is 1 + Arcos2.



%% ---------- Breath First ---------------------------------------------------

%% Com distância
pdCustoTodasSolucoes(L) :- findall((S),(resolve_pd(S)),L).

resolve_pd([Nodo|Caminho]) :-
	inicial(Nodo),
    breathFirst(Nodo, [Nodo], Caminho).

breathFirst(Nodo,_,[]) :- final(Nodo).

breathFirst(Nodo,Historico,Caminho) :-
	findall(X,
            (arco(X,Nodo,_),not(member(X,Historico))),
            [T|Extend]),
    append(Historico, [T|Extend], Historico2),
    append(Caminho, [T|Extend], [Next|Caminho2]),
    breathFirst(Next,Historico2,Caminho2).

%% Busca limitada em profundidade -----------------------------------------------------------
pplArcosTodasSolucoes(L,Max) :- findall((S,C),(resolve_pplArcos(S,C,Max)),L).

resolve_pplArcos([Nodo|Caminho],Arcos,Max) :-
	inicial(Nodo),
    profundidadeprimeiroLimArcos(Nodo, [Nodo], Caminho, Arcos,Max).

profundidadeprimeiroLimArcos(Nodo,_,[],0,_) :- final(Nodo).
profundidadeprimeiroLimArcos(Nodo,Historico,[ProxNodo|Caminho],Arcos,Max) :-
    arco(Nodo,ProxNodo,Dist),
    nao(membro(ProxNodo,Historico)),
    profundidadeprimeiroLimArcos(ProxNodo,[ProxNodo|Historico],Caminho,Arcos2,Max),
    Arcos is 1 + Arcos2,
    Arcos < Max.

%% Busca limitada em profundidade eficiencia ------------------------------------------------
pplCustosTodasSolucoes(L,Max) :- findall((S,E),(resolve_pplCusto(S,C,Max,E)),L).

resolve_pplCusto([Nodo|Caminho],Arcos,Max,Ef) :-
	inicial(Nodo),
    profundidadeprimeiroLimCusto(Nodo, [Nodo], Caminho, Arcos,Max,Dist),
    Ef is Dist/Arcos.

profundidadeprimeiroLimCusto(Nodo,_,[],0,_,_) :- final(Nodo).
profundidadeprimeiroLimCusto(Nodo,Historico,[ProxNodo|Caminho],Arcos,Max,Dis) :-
    arco(Nodo,ProxNodo,Dist),
    nao(membro(ProxNodo,Historico)),
    profundidadeprimeiroLimCusto(ProxNodo,[ProxNodo|Historico],Caminho,Arcos2,Max,Dis2),
    Arcos is 1 + Arcos2,
    Dis is Dist + Dis2,
    Arcos < Max.


%--------------------------------
% solução

adjacente3([Nodo|Caminho]/Custo/_,[ProxNodo,Nodo|Caminho]/NovoCusto/Est) :-
	(arco(Nodo,ProxNodo,PassoCusto) ; arco(ProxNodo,Nodo,PassoCusto)),
	nao(membro(ProxNodo,Caminho)),
	NovoCusto is Custo + PassoCusto,
	ponto_recolha(_,_,ProxNodo,_,Est).

adjacente2([Nodo|Caminho]/Custo/_,[ProxNodo,Nodo|Caminho]/NovoCusto/Est,Tipo) :-
	(arco(Nodo,ProxNodo,PassoCusto) ; arco(ProxNodo,Nodo,PassoCusto)),
	nao(membro(ProxNodo,Caminho)),
	NovoCusto is Custo + PassoCusto,
	ponto_recolha(_,_,ProxNodo,Tipo,Est).

%--------------------------------
% solução

resolve_gulosa(Caminho/Custo,Tipo) :-
	inicial(Nodo),
    ponto_recolha(_,_,Nodo,Tipo,Estima),
    agulosa([[Nodo]/0/Estima], InvCaminho/Custo/_,Tipo),
    inverso(InvCaminho,Caminho).

agulosa(Caminhos,Caminho,Tipo) :-
    obtem_melhor_g(Caminhos,Caminho),
    Caminho = [Nodo|_]/_/_,
    final(Nodo).

agulosa(Caminhos,SolucaoCaminho,Tipo) :-
    obtem_melhor_g(Caminhos, MelhorCaminho),
    seleciona(MelhorCaminho,Caminhos,OutrosCaminhos),
    expande_gulosa(MelhorCaminho,ExpCaminhos,Tipo),
    append(OutrosCaminhos, ExpCaminhos, NovosCaminhos),
    agulosa(NovosCaminhos,SolucaoCaminho,Tipo).

expande_gulosa(Caminho,ExpCaminhos,Tipo):-
    findall(NovoCaminho,adjacente2(Caminho,NovoCaminho,Tipo), ExpCaminhos).

obtem_melhor_g([Caminho],Caminho) :- !.

obtem_melhor_g([Caminho1/Custo1/Est1,_/Custo2/Est2|Caminhos], MelhorCaminho):-
    Est1 =< Est2, !,
    obtem_melhor_g([Caminho1/Custo1/Est1|Caminhos],MelhorCaminho).

obtem_melhor_g([_|Caminhos],MelhorCaminho) :-
    obtem_melhor_g(Caminhos, MelhorCaminho).

%--------------------------------------------
% Pesquisa A*

resolve_aestrela(Caminho/Custo) :-
	inicial(Nodo),
    ponto_recolha(_,_,Nodo,_,Estima),
    aestrela([[Nodo]/0/Estima], InvCaminho/Custo/_),
    inverso(InvCaminho,Caminho).

aestrela(Caminhos,Caminho) :-
    obtem_melhor(Caminhos,Caminho),
    Caminho = [Nodo|_]/_/_,
    final(Nodo).

aestrela(Caminhos,SolucaoCaminho) :-
    obtem_melhor(Caminhos, MelhorCaminho),
    seleciona(MelhorCaminho,Caminhos,OutrosCaminhos),
    expande_aestrela(MelhorCaminho,ExpCaminhos),
    append(OutrosCaminhos, ExpCaminhos, NovosCaminhos),
    aestrela(NovosCaminhos,SolucaoCaminho).

expande_aestrela(Caminho,ExpCaminhos):-
    findall(NovoCaminho,adjacente3(Caminho,NovoCaminho), ExpCaminhos).

obtem_melhor([Caminho],Caminho) :- !.

obtem_melhor([Caminho1/Custo1/Est1,_/Custo2/Est2|Caminhos], MelhorCaminho):-
    Est1 + Custo1 =< Est2 + Custo2, !,
    obtem_melhor([Caminho1/Custo1/Est1|Caminhos],MelhorCaminho).

obtem_melhor([_|Caminhos],MelhorCaminho) :-
    obtem_melhor(Caminhos, MelhorCaminho).

% ----------- Auxiliares ----------


nao( Questao ) :-
    Questao, !, fail.
nao( Questao ).

membro(X, [X|_]).
membro(X, [_|Xs]):-
membro(X, Xs).

minimo([(P,X)],(P,X)).
minimo([(P,X)|L],(Py,Y)):- minimo(L,(Py,Y)), X>Y.
minimo([(Px,X)|L],(Px,X)):- minimo(L,(Py,Y)), Y>=X.

escreve([]).
escreve([X|L]):-write(X),nl,escreve(L).

inverso(Xs,Ys):-
    inverso(Xs,[],Ys).

inverso([],Xs,Xs).
inverso([X|Xs],Ys,Zs):-
    inverso(Xs,[X|Ys],Zs).

seleciona(E, [E|Xs], Xs).
seleciona(E, [X|Xs], [X|Ys]) :- seleciona(E,Xs,Ys).