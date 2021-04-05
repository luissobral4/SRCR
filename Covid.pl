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
:- dynamic data/3.

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado utente : ID Utente, Segurança_Social, Nome, Data_Nasc, Email, Telefone, Morada, Profissão, LDoencas, CentroSaúde -> {V,F}

utente(1,21455655,'luis','2000','luis@gmail.com',936696454,'Adaúfe','Estudante',['cancro'],1).
utente(2,31455655,'Filipe','2001','Filipe@gmail.com',936696100,'Barcelos','Estudante',['cancro'],1).
utente(3,41455655,'José','2001','j@gmail.com',936696151,'Esposende','Estudante',['cancro'],1).
utente(4,42455655,'Diogo','2002','d@gmail.com',936696171,'Aveiro','Estudante',['cancro'],1).
utente(5,43455655,'Rui','2000','r@gmail.com',936696190,'Braga','Estudante',['cancro'],1).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado 'centro_saude' : ID Centro, Nome, Morada, Telefone, 
% Email -> {V,F}

centro_saude(1,'BragaH','Braga','999999999','BragaH@gmail.com').

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado 'staff' : ID staff, ID Centro, Nome, Email -> {V,F}

staff(1,1,'Luís','luis@gmail.com').

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado 'vacinacao_Covid' : ID staff, ID Utente, Data, Vacina, Toma -> {V,F}

vacinacao_Covid(1,1,21,8,2021,'Pfizer',1).
vacinacao_Covid(1,2,22,8,2021,'Pfizer',1).
vacinacao_Covid(1,2,22,9,2021,'Pfizer',2).
vacinacao_Covid(1,3,23,9,2021,'Pfizer',1).



%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Invariante Estrutural:  nao permite a insercao de conhecimento repetido

+utente(ID,Q,Nome,Da,E,T,M,P,D,C)::
	(solucoes((ID,Q,Nome,Da,E,T,M,P,D,C),utente(ID,Q,Nome,Da,E,T,M,P,D,C),Lista),
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
% Invariante Referencial: nao admite ids repetidos

+utente(ID,Q,Nom,Data,E,T,M,P,D,C)::
	(solucoes(ID,utente(ID,Ns,Nome,Dat,Em,Tel,Mor,Pr,Dc,Cs),Lista),
	comprimento(Lista,N), N==1).

+centro_saude(Id,Nome,Morada,Tel,Email)::
	(solucoes(Id,centro_saude(Id,No,Mor,Te,Ema),Lista),
	comprimento(Lista,N), N==1).

+staff(Id,IdCentro,Nome,Email)::
	(solucoes(Id,staff(Id,IdC,N,E),Lista),
	comprimento(Lista,N), N==1).

+vacinacao_Covid(ID_Staff,ID_Utente,Dia,Mes,Ano,Vacina,Toma)::
	(solucoes((ID_Utente,Toma)
			   vacinacao_Covid(ID,ID_Utente,D,M,A,V,Toma),
			   Lista),
	comprimento(Lista,N), N==1).


% Invariante Referencial: nao admitir vacinas associadas a uma data inválida
+vacinacao_Covid(ID_Staff,ID_Utente,Dia,Mes,Ano,Vacina,Toma):: data(Ano, Mes, Dia).

% Invariante Referencial: nao admitir vacinas associadas um staff ou utente inválido
+vacinacao_Covid(ID_Staff,ID_Utente,Dia,Mes,Ano,Vacina,Toma):: (utente(ID_Utente,Q,No,Da,E,T,M,P,D,C),staff(ID_Staff,IdCentro,Nome,Email)).

% Invariante Referencial: nao admitir utentes associados um centro de saúde inválido
+utente(ID_Utente,Q,N,Da,E,T,M,P,D,ID_Centro):: (centro_saude(ID_Centro,Nome,Morada,Tel,Email)).

% Invariante Referencial: nao admitir utentes com telefone inválido
+utente(ID_Utente,Q,N,Da,E,T,M,P,D,ID_Centro):: telefone(T).


% Invariante: Telefone tem que ser válido
+centro_saude(Id,Nome,Morada,Tel,Email) :- Tel >= 900000000, Tel <= 999999999.

% Invariante: IDs têm que ser números naturais
+utente(ID,Q,No,Da,E,T,M,P,D,C) :- natural(ID).
+centro_saude(Id,Nome,Morada,Tel,Email) :- natural(ID).
+staff(Id,IdCentro,Nome,Email) :- natural(ID).



-utente(ID,Q,N,D,E,T,M,P,D,C)::
	(solucoes(ID,utente(ID,Q,Ns,D,E,T,M,P,D,C),Lista),
	comprimento(Lista,N), N==1).

-centro_saude(Id,Nome,Morada,Tel,Email)::
	(solucoes(Id,centro_saude(Id,Nome,Morada,Tel,Email),Lista),
	comprimento(Lista,N), N==1).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% remover utentes, CentroSaúde , staff e Vacinas:
%--------------------------------- - - - - - - - - - -  -  -  -  -   -
removeUtente(ID,Q,No,Da,E,T,M,P,D,C) :- involucao(utente(ID,Q,No,Da,E,T,M,P,D,C)).

removeCentro(ID,N,M,T,E) :- involucao(centro_saude(ID,N,M,T,E)).

removeStaff(ID,IdCentro,Nome,Email) :- involucao(staff(ID,IdCentro,Nome,Email)).

removeVacina(ID_Staff,ID_Utente,Dia,Mes,Ano,Vacina,Toma) :- involucao(vacinacao_Covid(ID_Staff,ID_Utente,Dia,Mes,Ano,Vacina,Toma)).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% adicionar utentes, CentroSaúde , staff e Vacinas:
%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensão do predicado 'registaUtente': ID, Q, Nome, Data, E, T, M, P, D,C-> {V, F}
registaUtente(ID,Q,Nome,Data,E,T,M,P,D,C) :- evolucao(utente(ID,Q,Nome,Data,E,T,M,P,D,C)).

registaCentro(ID,N,M,T,E) :- evolucao(centro_saude(ID,N,M,T,E)).

registaStaff(ID,IdCentro,Nome,Email) :- evolucao(staff(ID,IdCentro,Nome,Email)).

registaVacina(ID_Staff,ID_Utente,Dia,Mes,Ano,Vacina,Toma) :- evolucao(vacinacao_Covid(ID_Staff,ID_Utente,Dia,Mes,Ano,Vacina,Toma)).


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% IDENTIFICAR UTENTES/VACINAS/CENTROS/STAFF POR CRITÉRIOS DE SELEÇÃO
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

vacinas(R) :- solucoes((ID,IDU,D,M,A,V,T), vacinacao_Covid(ID,IDU,D,M,A,V,T), R).

staffID(ID,R) :- solucoes((ID,I,N,E), staff(ID,I,N,E), R).

centroID(ID,R) :- solucoes((ID,N,M,T,E), centro_saude(ID,N,M,T,E), R).

centroT(R) :- solucoes((ID,N,M,T,E), centro_saude(ID,N,M,T,E), R).


% Extensão do predicado que permite identificar utentes:
% 'utenteT': Resultado -> {V,F}
utenteT(R) :- solucoes((ID,Q,No,Da,E,T,M,P,D,C), utente(ID,Q,No,Da,E,T,M,P,D,C), R).

% Extensão do predicado que permite identificar utentes vacinados
% 'utentesVacinados': Resultado -> {V, F}
utentesVacinados(R) :- solucoes((ID,Dia,Mes,Ano),vacinacao_Covid(ID_Staff,ID,Dia,Mes,Ano,Vacina,Toma),R).

% Extensão do predicado que permite identificar utentes não vacinados
% 'utentesNVacinados': Resultado -> {V, F}
utentesNVacinados(R) :- solucoes(IDU,utente(IDU,Q,No,Da,E,T,M,P,D,C),LUtentes),solucoes(ID,vacinacao_Covid(ID_Staff,ID,Dia,Mes,Ano,Vacina,Toma),LVacinados),removeVacinados(LUtentes,LVacinados,R).

lVacinados(R) :- solucoes(ID,vacinacao_Covid(ID_Staff,ID,Dia,Mes,Ano,Vacina,Toma),L), removeRepetidos(L,R).
lUtentes(R) :- solucoes(IDU,utente(IDU,Q,No,Da,E,T,M,P,D,C),R).

removeVacinados([], R, []).
removeVacinados([H|T], R, L) :- contains(H, R) , removeVacinados(T, R, L). 
removeVacinados([H|T], R, [H|L]) :- nao(contains(H, T)) , removeVacinados(T, R, L).

% Extensão do predicado que permite identificar utentes a quem falta a 2ª toma da vacina
% 'utentes2toma': Resultado -> {V, F}
utentes2toma(R) :- solucoes(ID,vacinacao_Covid(ID_Staff,ID,Dia,Mes,Ano,Vacina,2),L2Toma),solucoes(IDU,vacinacao_Covid(ID_Staff,IDU,Dia,Mes,Ano,Vacina,Toma),LVacinados), removeVacinados(LVacinados,L2Toma,R).

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
% Extensao do meta-predicado nao: Questao -> {V,F}

nao( Questao ) :-
    Questao, !, fail.
nao( Questao ).


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensão do predicado que permite verificar se um elemento percente a uma lista: 
% 'contains':  Elemento, Conjunto -> {V,F}

contains(E,[E|T]).
contains(E,[Y|T]) :- E\=Y, contains(E,T).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensão do predicado que permite verificar se um numero é natural: 
% 'natural':  Numero -> {V,F}
natural(1).
natural(N) :- M is N-1 , natural(M).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -

solucoes( X,Y,Z ) :-
    findall( X,Y,Z ).

comprimento( S,N ) :-
    length( S,N ).

% Extensão do predicado 'bissexto': Ano => {V, F}
bissexto(X) :- X mod 4 == 0.

% Extensão do predicado 'data': Ano, Mes, Dia => {V, F}
data(A,M,D) :- M\=2, A>=2010, contains(M,[1,3,5,7,8,10,12]), D>=0, D=<31.
data(A,M,D) :- M\=2, A>=2010, contains(M,[4,6,9,11]), D>0, D=<30.
data(A,M,D) :- M==2 , bissexto(A), A>=2010, D>0, D=<29.
data(A,M,D) :- M==2 , nao(bissexto(A)), A>=2010, D>0, D=<28.

% Extensão do predicado 'removeRepetidos' que remove os elementos repetidos duma lista
removeRepetidos([], []).
removeRepetidos([H|T], R) :- contains(H, T) , removeRepetidos(T, R). 
removeRepetidos([H|T], [H|R]) :- nao(contains(H, T)) , removeRepetidos(T, R).