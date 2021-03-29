%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Base de Conhecimento com informacao utentes, centro_saude, staff,vacinaçao.


% SICStus PROLOG: Declaracoes iniciais
:- set_prolog_flag( discontiguous_warnings,off ).
:- set_prolog_flag( single_var_warnings,off ).
:- set_prolog_flag( unknown,fail ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Definicoes iniciais

:- op( 900,xfy,'::' ).
:- dynamic utente/10.
:- dynamic centro_saude/5.
:- dynamic staff/4.
:- dynamic vacinacao_Covid/7.

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado 'utente' : Id Utente, Segurança_Social, Nome, Data_Nasc, Email, 
% Telefone, Morada, Profissão, [Doenças_Crónicas], CentroSaúde -> {V,F}

utente(1,21,'Luís','2000-08-21','luis@gmail.com','936696106','Adaúfe','Estudante',[],'c1').

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado 'centro_saude' : Id Centro, Nome, Morada, Telefone, 
% Email -> {V,F}

centro_saude(1,'BragaH','Braga','999999999','BragaH@gmail.com').

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado 'staff' : Id staff, Id Centro, Nome, Email -> {V,F}

staff(1,1,'Luís','luis@gmail.com').

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado 'vacinacao_Covid' : Id staff, Id Utente, Data, Vacina, Toma -> {V,F}

vacinacao_Covid(1,1,21,8,2021,'Pfizer',1).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Invariante Estrutural:  nao permite a insercao de conhecimento repetido

+utente(ID,Q,N,D,E,T,M,P,D,C)::
	(solucoes((ID,Q,N,D,E,T,M,P,D,C),utente(ID,Q,N,D,E,T,M,P,D,C),Lista),
	comprimento(Lista,N), N==1).

+centro_saude(Id,Nome,Morada,Tel,Email)::
	(solucoes((Id,Nome,Morada,Tel,Email),centro_saude(Id,Nome,Morada,Tel,Email),Lista),
	comprimento(Lista,N), N==1).

+staff(Id,IdCentro,Nome,Email)::
	(solucoes((Id,IdCentro,Nome,Email),staff(Id,IdCentro,Nome,Email),Lista),
	comprimento(Lista,N), N==1).

+vacinacao_Covid(ID_Staff,ID_Utente,Dia,Mes,Ano,Vacina,Toma)::
	(solucoes((ID_Staff,ID_Utente,Dia,Mes,Ano,Vacina,Toma),vacinacao_Covid(ID_Staff,ID_Utente,Dia,Mes,Ano,Vacina,Toma),Lista),
	comprimento(Lista,N), N==1).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Invariante Referencial: nao admite ids repetido

+utente(ID,Q,N,D,E,T,M,P,D,C)::
	(solucoes(ID,utente(ID,Ns,Nome,Dat,Em,Tel,Mor,Pr,Dc,Cs),Lista),
	comprimento(Lista,N), N==1).

+centro_saude(Id,Nome,Morada,Tel,Email)::
	(solucoes(Id,centro_saude(Id,No,Mor,Te,Ema),Lista),
	comprimento(Lista,N), N==1).

+staff(Id,IdCentro,Nome,Email)::
	(solucoes(Id,staff(Id,IdC,N,E),Lista),
	comprimento(Lista,N), N==1).

+vacinacao_Covid(ID_Staff,ID_Utente,Dia,Mes,Ano,Vacina,Toma)::
	(solucoes(ID_Utente,
			   vacinacao_Covid(ID,ID_Utente,D,M,A,V,T),
			   Lista),
	comprimento(Lista,N), N==1).




-utente(ID,Q,N,D,E,T,M,P,D,C)::
	(solucoes(ID,utente(ID,Q,N,D,E,T,M,P,D,C),Lista),
	comprimento(Lista,N), N==1).

-centro_saude(Id,Nome,Morada,Tel,Email)::
	(solucoes(Id,centro_saude(Id,Nome,Morada,Tel,Email),Lista),
	comprimento(Lista,N), N==1).


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% remover utentes, CentroSaúde , staff e Vacinas:
%--------------------------------- - - - - - - - - - -  -  -  -  -   -
removeUtente(ID,Q,N,D,E,T,M,P,D,C) :- involucao(utente(ID,Q,N,D,E,T,M,P,D,C)).

removeCentro(ID,N,M,T,E) :- involucao(centro_saude(ID,N,M,T,E)).

removeStaff(ID,IdCentro,Nome,Email) :- involucao(staff(ID,IdCentro,Nome,Email)).

removeVacina(ID_Staff,ID_Utente,Dia,Mes,Ano,Vacina,Toma) :- involucao(vacinacao_Covid(ID_Staff,ID_Utente,Dia,Mes,Ano,Vacina,Toma)).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% adicionar utentes, CentroSaúde , staff e Vacinas:
%--------------------------------- - - - - - - - - - -  -  -  -  -   -
registaUtente(ID,Q,N,D,E,T,M,P,D,C) :- evolucao(utente(ID,Q,N,D,E,T,M,P,D,C)).

registaCentro(ID,N,M,T,E) :- evolucao(centro_saude(ID,N,M,T,E)).

registaStaff(ID,IdCentro,Nome,Email) :- evolucao(staff(ID,IdCentro,Nome,Email)).

registaVacina(ID_Staff,ID_Utente,Dia,Mes,Ano,Vacina,Toma) :- evolucao(vacinacao_Covid(ID_Staff,ID_Utente,Dia,Mes,Ano,Vacina,Toma)).



vacinas(R) :- solucoes((ID,IDU,D,M,A,V,T), vacinacao_Covid(ID,IDU,D,M,A,V,T), R).

staffID(ID,R) :- solucoes((ID,I,N,E), staff(ID,I,N,E), R).

centroID(ID,R) :- solucoes((ID,N,M,T,E), centro_saude(ID,N,M,T,E), R).

centroT(R) :- solucoes((ID,N,M,T,E), centro_saude(ID,N,M,T,E), R).

utenteT(R) :- solucoes((ID,Q,N,D,E,T,M,P,D,C), utente(ID,Q,N,D,E,T,M,P,D,C), R).

utenteID(ID,R) :- solucoes((ID,Q,N,D,E,T,M,P,D,C), utente(ID,Q,N,D,E,T,M,P,D,C), R).

utenteNr(Q,R) :- solucoes((ID,Q,N,D,E,T,M,P,D,C), utente(ID,Q,N,D,E,T,M,P,D,C), R).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -

evolucao( Termo ) :-
    solucoes( Invariante,+Termo::Invariante,Lista ),
    insercao( Termo ),
    teste( Lista ).

insercao( Termo ) :-
    assert( Termo ).
insercao( Termo ) :-
    retract( Termo ),!,fail.

teste( [] ).
teste( [R|LR] ) :-
    R,
    teste( LR ).


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do meta-predicado nao: Questao -> {V,F}

nao( Questao ) :-
    Questao, !, fail.
nao( Questao ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado que permite a involucao do conhecimento

involucao( Termo ) :-
    solucoes( Invariante,-Termo::Invariante,Lista ),
    remocao( Termo ),
    teste( Lista ).

remocao( Termo ) :-
    retract( Termo ).
remocao( Termo ) :-
    assert( Termo ),!,fail.

%--------------------------------- - - - - - - - - - -  -  -  -  -   -

solucoes( X,Y,Z ) :-
    findall( X,Y,Z ).

comprimento( S,N ) :-
    length( S,N ).