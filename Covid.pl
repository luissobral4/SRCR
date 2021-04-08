% Base de Conhecimento com informacao utentes, centro_saude, staff,vacinaçao.


% SICStus PROLOG: Declaracoes iniciais
:- style_check(-discontiguous).
:- style_check(-singleton).

% Definicoes iniciais

:- op( 900,xfy,'::' ).
:- dynamic utente/10.
:- dynamic centro_saude/5.
:- dynamic staff/4.
:- dynamic vacinacao_Covid/7. 
:- dynamic data/3.

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% POVOAMENTO
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% Extensao do predicado utente : ID Utente, Segurança_Social, Nome, Data_Nasc, Email, Telefone, Morada, Profissão, LDoencas, CentroSaúde -> {V,F}
utente(1,21455655,'Luís',1970,'luis@gmail.com',936696454,'Adaúfe','Estudante',['Doença coronária','Doença respiratória'],1).
utente(2,31455655,'Filipe',1969,'filipe@gmail.com',936696100,'Barcelos','Estudante',['Diabetes'],1). 
utente(3,41455655,'José',1990,'j@gmail.com',936696151,'Esposende','Estudante',[],1).
utente(4,42455655,'Diogo',1998,'d@gmail.com',936696171,'Aveiro','Estudante',['Doença coronária'],1).
utente(5,43455655,'Rui',1936,'r@gmail.com',936696190,'Braga','Estudante',['Diabetes'],1).
utente(6,41454355,'Paulo',1980,'p@gmail.com',936738461,'Esposende','Medico',[],2).
utente(7,75355655,'Beatriz',1995,'b@gmail.com',936973645,'Aveiro','Enfermeiro',[],2).
utente(8,43455692,'Maria',1951,'m@gmail.com',912348248,'Braga','Estudante',[],2).
utente(9,42487435,'Carlos',1983,'c@gmail.com',936827634,'Aveiro','Estudante',['Arteroses'],2).

% Extensao do predicado 'centro_saude' : ID Centro, Nome, Morada, Telefone, 
% Email -> {V,F}
centro_saude(1,'BragaH','Braga','999999999','bragah@gmail.com').
centro_saude(2,'GuimaraesH','GuimaraesH','999999998','guimaraesh@gmail.com').

% Extensao do predicado 'staff' : ID staff, ID Centro, Nome, Email -> {V,F}
staff(1,1,'Luís','luis@gmail.com').
staff(2,2,'Paulo','paulo@gmail.com').
staff(3,1,'Francisco','francisco@gmail.com').
staff(4,2,'João','joao@gmail.com').

% Extensao do predicado 'vacinacao_Covid' : ID staff, ID Utente, Data, Vacina, Toma -> {V,F}
% Utente 1 - 2 vacinas fase 1
vacinacao_Covid(1, 1, 11, 1, 2021, 'AstraZeneca', 1).
vacinacao_Covid(1, 1, 11, 4, 2021, 'AstraZeneca', 2).
vacinacao_Covid(3, 2, 30, 5, 2021, 'Moderna', 1).
vacinacao_Covid(2, 3, 12, 5, 2021, 'PFizer', 1).
vacinacao_Covid(1, 4, 11, 11, 2021, 'Moderna', 1).
vacinacao_Covid(1, 4, 14, 12, 2021, 'Moderna', 2).
vacinacao_Covid(4, 6, 12, 2, 2021, 'PFizer', 1).
vacinacao_Covid(4, 6, 12, 3, 2021, 'PFizer', 2).
vacinacao_Covid(2, 7, 1, 3, 2021, 'AstraZeneca', 2).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% INVARIANTES
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% Invariante:  nao permite a insercao de conhecimento repetido
+utente(ID,_,_,_,_,_,_,_,_,_)::
	(solucoes(ID,utente(ID,_,_,_,_,_,_,_,_,_),Lista),
	comprimento(Lista,N), N==1).

+utente(_,SS,_,_,_,_,_,_,_,_)::
	(solucoes(SS,utente(_,SS,_,_,_,_,_,_,_,_),Lista),
	comprimento(Lista,N), N==1).

+utente(_,_,_,_,E,_,_,_,_,_)::
	(solucoes(E,utente(_,_,_,_,E,_,_,_,_,_),Lista),
	comprimento(Lista,N), N==1).

+utente(_,_,_,_,_,T,_,_,_,_)::
	(solucoes(T,utente(_,_,_,_,_,T,_,_,_,_),Lista),
	comprimento(Lista,N), N==1).

+centro_saude(ID,_,_,_,_)::
	(solucoes(ID,centro_saude(ID,_,_,_,_),Lista),
	comprimento(Lista,N), N==1).

+centro_saude(_,_,_,T,_)::
	(solucoes(T,centro_saude(_,_,_,T,_),Lista),
	comprimento(Lista,N), N==1).

+centro_saude(_,_,_,_,E)::
	(solucoes(E,centro_saude(_,_,_,_,E),Lista),
	comprimento(Lista,N), N==1).

+staff(ID,_,_,_)::
	(solucoes(ID,staff(ID,_,_,_),Lista),
	comprimento(Lista,N), N==1).

+staff(_,_,_,E)::
	(solucoes(E,staff(_,_,_,E),Lista),
	comprimento(Lista,N), N==1).

+vacinacao_Covid(_,ID_Utente,_,_,_,_,Toma)::
	(solucoes((ID_Utente,Toma),vacinacao_Covid(_,ID_Utente,_,_,_,_,Toma),Lista),
	comprimento(Lista,N), N==1).

% Invariante:  nao permite a remoção de conhecimento inexistente
-utente(ID,_,_,_,_,_,_,_,_,_)::
	(solucoes(ID,utente(ID,_,_,_,_,_,_,_,_,_),Lista),
	comprimento(Lista,N), N==1).

-centro_saude(ID,_,_,_,_)::
	(solucoes(ID,centro_saude(ID,_,_,_,_),Lista),
	comprimento(Lista,N), N==1).

-staff(ID,_,_,_)::
	(solucoes((ID,_,_,_),staff(ID,_,_,_),Lista),
	comprimento(Lista,N), N==1).

-vacinacao_Covid(_,ID_Utente,_,_,_,_,Toma)::
	(solucoes((ID_Utente,Toma),vacinacao_Covid(_,ID_Utente,_,_,_,_,Toma),Lista),
	comprimento(Lista,N), N==1).


% Invariante: IDs têm que ser números naturais
+utente(ID,_,_,_,_,_,_,_,_,_):: natural(ID).
+centro_saude(ID,_,_,_,_):: natural(ID).
+staff(ID,_,_,_):: natural(ID).


% Invariante: nao admitir vacinas associadas a uma data inválida
+vacinacao_Covid(ID_Staff,ID_Utente,Dia,Mes,Ano,Vacina,Toma):: data(Ano, Mes, Dia).

% Invariante: nao admitir vacinas associadas um staff ou utente inválido
+vacinacao_Covid(ID_Staff,ID_Utente,Dia,Mes,Ano,Vacina,Toma):: (utente(ID_Utente,Q,No,Da,E,T,M,P,D,C),staff(ID_Staff,IdCentro,Nome,Email)).

% Invariante: nao admitir mais de duas tomas da vacina
+vacinacao_Covid(_,_,_,_,_,_,Toma):: contains(Toma,[1,2]).

% Invariante: nao admitir segunda toma da vacina sem tomar a primeira
+vacinacao_Covid(_,ID_Utente,_,_,_,_,2):: vacinacao_Covid(_,ID_Utente,_,_,_,_,1).

% Invariante: nao admitir segunda toma da vacina diferente da primeira
+vacinacao_Covid(_,ID_Utente,_,_,_,Vacina,2):: vacinacao_Covid(_,ID_Utente,_,_,_,Vacina,1).

% Invariante: nao admitir utentes associados um centro de saúde inválido
+utente(_,_,_,_,_,_,_,_,_,ID_Centro):: (centro_saude(ID_Centro,_,_,_,_)).

% Invariante: nao admitir utentes com telefone inválido
+utente(_,_,_,_,_,Tel,_,_,_,_):: telefone(Tel).

% Invariante: Telefone tem que ser válido
+centro_saude(_,_,_,Tel,_):: telefone(Tel).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% EVOLUÇÃO DE CONHECIMENTO
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% Extensao do predicado que permite a evolução do conhecimento
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
% INVOLUÇÃO DE CONHECIMENTO
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% Extensao do predicado que permite a involucao do conhecimento
involucao( Termo ) :-
    solucoes( Invariante,-Termo::Invariante,Lista ),
	teste( Lista ),
    remocao( Termo ).
    

remocao( Termo ) :-
    retract( Termo ).
remocao( Termo ) :-
    assert( Termo ),!,fail.

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% ADIÇÃO DE CONHECIMENTO
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

registaUtente(ID,Q,Nome,Data,E,T,M,P,D,C) :- evolucao(utente(ID,Q,Nome,Data,E,T,M,P,D,C)).

registaCentro(ID,N,M,T,E) :- evolucao(centro_saude(ID,N,M,T,E)).

registaStaff(ID,IdCentro,Nome,Email) :- evolucao(staff(ID,IdCentro,Nome,Email)).

registaVacina(ID_Staff,ID_Utente,Dia,Mes,Ano,Vacina,Toma) :- evolucao(vacinacao_Covid(ID_Staff,ID_Utente,Dia,Mes,Ano,Vacina,Toma)).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% REMOÇÃO DE CONHECIMENTO
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

removeUtente(ID) :- vacinasUtente(ID,R), removeVacinasUtente(R), involucao(utente(ID,_,_,_,_,_,_,_,_,_)).

vacinasUtente(ID,R) :- solucoes(ID, (vacinacao_Covid(_,ID,_,_,_,_,_)), R).

removeVacinasUtente([]).
removeVacinasUtente([ID|T]) :- involucao(vacinacao_Covid(ID_Staff,ID,D,M,A,Vacina,Toma)), removeVacinasUtente(T).


removeCentro(ID) :- staffCentro(ID,R), removeStaffCentro(R), involucao(centro_saude(ID,_,_,_,_)).

staffCentro(ID,R) :- solucoes(ID_Staff, (staff(ID_Staff,ID,_,_)), R).

removeStaffCentro([]).
removeStaffCentro([ID|T]) :- involucao(staff(ID,_,_,_)), removeStaffCentro(T).


removeStaff(ID) :- involucao(staff(ID,_,_,_)).

removeVacina(ID_Utente,Toma) :- involucao(vacinacao_Covid(_,ID_Utente,_,_,_,_,Toma)).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% PERMITIR DEFINIÇÃO DE FASES DE VACINAÇÃO
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% Extensão do predicado que permite identificar utentes que pertencem à primeira fase de vacinação
% 'utentes1fase': Resultado -> {V, F}
utentes1fase(R) :- solucoes(ID, (utente(ID,_,_,A,_,_,_,P,L,_), criterios1fase(A,P,L)), R).

% Extensão do predicado que permite identificar utentes que pertencem à segunda fase de vacinação
% 'utentes2fase': Resultado -> {V, F}
utentes2fase(R) :- solucoes(ID, (utente(ID,_,_,A,_,_,_,P,L,_), criterios2fase(A,P,L)), R).

% Extensão do predicado que permite identificar utentes que pertencem à terceira fase de vacinação
% 'utentes3fase': Resultado -> {V, F}
utentes3fase(R) :- solucoes(ID, (utente(ID,_,_,A,_,_,_,P,L,_), criterios3fase(A,P,L)), R).

% Extensão do predicado que permite identificar utentes que foram vacinados na primeira fase
% 'vacinados1fase': Resultado -> {V, F}
vacinados1fase(R) :- solucoes(ID, (vacinacao_Covid(_,ID,_,M,_,_,1),M<5), R).

% Extensão do predicado que permite identificar utentes que foram vacinados na segunda fase
% 'vacinados2fase': Resultado -> {V, F}
vacinados2fase(R) :- solucoes(ID, (vacinacao_Covid(_,ID,_,M,_,_,1),M>4,M<10), R).

% Extensão do predicado que permite identificar utentes que foram vacinados na terceira fase
% 'vacinados3fase': Resultado -> {V, F}
vacinados3fase(R) :- solucoes(ID, (vacinacao_Covid(_,ID,_,M,_,_,1),M>9), R).

% Extensão do predicado que permite identificar criterios da 1ª fase
% 'criterios1fase': Resultado -> {V, F}
criterios1fase(Ano,Profissao,LDoencas) :- 2021 - Ano >= 80.
criterios1fase(Ano,Profissao,LDoencas) :- profissaoRisco(Profissao).
criterios1fase(Ano,Profissao,LDoencas) :- listaDoencas(LDoencas), 2021 - Ano >= 50.

% Extensão do predicado que permite identificar criterios da 2ª fase
% 'criterios2fase': Resultado -> {V, F}
criterios2fase(Ano,Profissao,LDoencas) :- not(profissaoRisco(Profissao)), not(listaDoencas(LDoencas)),2021 - Ano >= 65, 2021 - Ano < 80.
criterios2fase(Ano,Profissao,LDoencas) :- not(profissaoRisco(Profissao)), not(listaDoencas(LDoencas)),listaDoencas2(LDoencas), 2021 - Ano >= 50, 2021 - Ano < 65.

% Extensão do predicado que permite identificar criterios da 3ª fase
% 'criterios3fase': Resultado -> {V, F}
criterios3fase(Ano,Profissao,LDoencas) :- not(profissaoRisco(Profissao)), 2021 - Ano < 50.
criterios3fase(Ano,Profissao,LDoencas) :- not(profissaoRisco(Profissao)), not(listaDoencas(LDoencas)),not(listaDoencas2(LDoencas)), 2021 - Ano >= 50, 2021 - Ano < 65.

% Extensão do predicado que permite identificar se uma lista contém uma doença de risco 1
% 'listaDoencas': Resultado -> {V, F}
listaDoencas([H|T]) :- doencaRisco(H).
listaDoencas([H|T]) :- not(doencaRisco(H)), listaDoencas(T).

% Extensão do predicado que permite identificar se uma lista contém uma doença de risco 2
% 'listaDoencas': Resultado -> {V, F}
listaDoencas2([H|T]) :- doencaRisco2(H).
listaDoencas2([H|T]) :- not(doencaRisco2(H)), listaDoencas2(T).

% Extensão do predicado que permite identificar se uma doença é de risco 1
% 'listaDoencas': Resultado -> {V, F}
doencaRisco('Insuficiência cardíaca').
doencaRisco('Doença coronária').
doencaRisco('Insuficiência renal').
doencaRisco('Doença respiratória').

% Extensão do predicado que permite identificar se uma doença é de risco 2
% 'listaDoencas': Resultado -> {V, F}
doencaRisco2('Diabetes').
doencaRisco2('Insuficiência hepática').
doencaRisco2('Hipertensão arterial').
doencaRisco2('Obesidade').

% Extensão do predicado que permite identificar se uma profissão é de risco
% 'listaDoencas': Resultado -> {V, F}
profissaoRisco('Medico').
profissaoRisco('Enfermeiro').
profissaoRisco('Militar').
profissaoRisco('Segurança').
profissaoRisco('Residente de lar de idosos').

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% IDENTIFICAR PESSOAS VACINADAS
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% Extensão do predicado que permite identificar utentes vacinados
% 'utentesVacinados': Resultado -> {V, F}
utentesVacinados(R) :- solucoes(ID,vacinacao_Covid(_,ID,_,_,_,_,_),L), removeRepetidos(L,R).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% IDENTIFICAR PESSOAS NÃO VACINADAS
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% Extensão do predicado que permite identificar utentes não vacinados
% 'utentesNVacinados': Resultado -> {V, F}
utentesNVacinados(R) :- solucoes(ID,(utente(ID,_,_,_,_,_,_,_,_,_),utentesVacinados(LVacinados),nao(contains(ID,LVacinados))),R).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% IDENTIFICAR PESSOAS VACINADAS INDEVIDAMENTE
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% Extensão do predicado que permite identificar utentes vacinados indevidamente
% 'utentesVacinadosInd': Resultado -> {V, F}
utentesVacinadosInd(R) :- utentesInd1(L1),utentesInd2(L2),concat(L1,L2,L),utentesInd3(L3),concat(L, L3, R).

utentesInd1(R) :- solucoes(ID, (utente(ID,_,_,_,_,_,_,_,_,_),utentes1fase(UF1),vacinados2fase(VF1),contains(ID,UF1),contains(ID,VF1)), L2), solucoes(ID, (utente(ID,_,_,_,_,_,_,_,_,_),utentes1fase(UF2),vacinados3fase(VF2),contains(ID,UF2),contains(ID,VF2)), L3), concat(L2,L3,R).
utentesInd2(R) :- solucoes(ID, (utente(ID,_,_,_,_,_,_,_,_,_),utentes2fase(UF1),vacinados1fase(VF1),contains(ID,UF1),contains(ID,VF1)), L1), solucoes(ID, (utente(ID,_,_,_,_,_,_,_,_,_),utentes2fase(UF2),vacinados3fase(VF2),contains(ID,UF2),contains(ID,VF2)), L3), concat(L1,L3,R).
utentesInd3(R) :- solucoes(ID, (utente(ID,_,_,_,_,_,_,_,_,_),utentes3fase(UF1),vacinados1fase(VF1),contains(ID,UF1),contains(ID,VF1)), L1), solucoes(ID, (utente(ID,_,_,_,_,_,_,_,_,_),utentes3fase(UF2),vacinados2fase(VF2),contains(ID,UF2),contains(ID,VF2)), L2), concat(L1,L2,R).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% IDENTIFICAR PESSOAS NÃO VACINADAS E QUE SÃO CANDIDATAS
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% Extensão do predicado que permite identificar utentes não vacinados que são candidatos
% 'utentesNVacinadosCan': Resultado -> {V, F}
utentesNVacinadosCan(R) :- solucoes(ID, (utente(ID,_,_,_,_,_,_,_,_,_),utentesNVacinados(LNV),utentes1fase(L1),utentes2fase(L2),concat(L1,L2,L),contains(ID,L),contains(ID,LNV)), R).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% IDENTIFICAR PESSOAS A QUEM FALTA A TOMA DA SEGUNDA VACINA
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% Extensão do predicado que permite identificar utentes que só tomaram a 1ª toma da vacina
% 'utentes1toma': Resultado -> {V, F}
utentes1toma(R) :- solucoes(ID,(vacinacao_Covid(_,ID,_,_,_,_,1),utentes2toma(L),nao(contains(ID,L))),R).

% Extensão do predicado que permite identificar utentes que tomaram a 2ª toma da vacina
% 'utentes2toma': Resultado -> {V, F}
utentes2toma(R) :- solucoes(ID,vacinacao_Covid(_,ID,_,_,_,_,2),R).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SISTEMA DE INFERÊNCIA
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

inferencia(Questao, verdadeiro) :- Questao.
inferencia(Questao, falso) :- -Questao.

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% EXTRA
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% LISTAR VACINACAO
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

vacinacao :- listing(vacinacao_Covid).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% IDENTIFICAR ELEMENTO DO STAFF POR ID
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

staffID(ID,R) :- solucoes((ID,I,N,E), staff(ID,I,N,E), R).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% LISTAR STAFF
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

staffT :- listing(staff).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% IDENTIFICAR CENTRO DE SAUDE POR ID
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

centroID(ID,R) :- solucoes((ID,N,M,T,E), centro_saude(ID,N,M,T,E), R).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% LISTAR CENTRO DE SAUDE
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

centroT :- listing(centro_saude).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% IDENTIFICAR UTENTE POR ID
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

utenteID(ID,R) :- solucoes((ID,Q,No,Da,E,T,M,P,D,C), utente(ID,Q,No,Da,E,T,M,P,D,C), R).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% LISTAR UTENTES
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

utenteT :- listing(utentes).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% IDENTIFICAR FASE DE VACINAÇÃO DE UM UTENTE
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

faseUtente(ID, 'Primeira Fase') :- utentes1fase(L), contains(ID, L).
faseUtente(ID, 'Segunda Fase') :- utentes2fase(L), contains(ID, L).
faseUtente(ID, 'Terceira Fase') :- utentes3fase(L), contains(ID, L). 

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% IDENTIFICAR CENTRO DE SAUDE DE UM STAFF
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

centroStaff(ID, Nome) :- staff(ID,ID_Centro,_,_), centro_saude(ID_Centro,Nome,_,_,_).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% IDENTIFICAR VACINAS DADAS POR UM MEMBRO DO STAFF
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

vacinasStaff(ID_Staff,R) :- solucoes(V, vacinacao_Covid(ID_Staff,_,_,_,_,V,_), L), removeRepetidos(L,R). 

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% IDENTIFICAR FREQUENCIA DAS VACINAS
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

ocorrencia_vacina(_,[],0).
ocorrencia_vacina(X,[X|T],Y) :- ocorrencia_vacina(X,T,Z), Y is Z+1.
ocorrencia_vacina(X,[_|T],Y) :- ocorrencia_vacina(X,T,Y).

vacina_lista([],_,_).
vacina_lista([H],L2,[(H,Q)]) :- ocorrencia_vacina(H,V,Q).
vacina_lista([H|T],L2,[(H,Q)|L]) :- ocorrencia_vacina(H,V,Q),vacina_lista(T,V,L).

frequenciaVacinas(R) :- solucoes(V, vacinacao_Covid(_,_,_,_,_,V,_), L), removeRepetidos(L,L2), vacina_lista(L2,L,R).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% PREDICADOS AUXILIARES
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% Extensao do meta-predicado nao: Questao -> {V,F}
nao( Questao ) :- Questao, !, fail.
nao( Questao ).

% Extensão do predicado que permite verificar se um elemento percente a uma lista: 
% 'contains':  Elemento, Conjunto -> {V,F}
contains(E,[E|T]).
contains(E,[Y|T]) :- E\=Y, contains(E,T).

% Extensão do predicado que permite verificar se um numero é natural: 
% 'natural':  Numero -> {V,F}
natural(1).
natural(N) :- M is N-1 , natural(M).

% Extensao do predicado «adicionar» que insere um elemento numa lista, sem o repetir: Elemento,Lista,Resultado -> {V,F}
add(E,L,L) :- contains(E,L).
add(E, L, [E|L]).

% Extensao do predicado «concatenar», que resulta na concatenação dos elementos da lista L1 com os elementos da lista L2: Lista1,Lista2,Resultado -> {V,F}
concat([], L, L).
concat([H|T], L, R) :- add(H, N, R), concat(T, L, N).

% Extensão do predicado 'solucoes'
solucoes( X,Y,Z ) :-
    findall( X,Y,Z ).

% Extensão do predicado 'solucoes'
comprimento( S,N ) :-
    length( S,N ).

% Extensão do predicado 'removeRepetidos' que remove os elementos repetidos duma lista
removeRepetidos([], []).
removeRepetidos([H|T], R) :- contains(H, T) , removeRepetidos(T, R). 
removeRepetidos([H|T], [H|R]) :- nao(contains(H, T)) , removeRepetidos(T, R).

% Extensão do predicado 'bissexto': Ano => {V, F}
bissexto(X) :- X mod 4 == 0.

% Extensão do predicado 'data': Ano, Mes, Dia => {V, F}
data(A,M,D) :- M\=2, A>=2010, contains(M,[1,3,5,7,8,10,12]), D>=0, D=<31.
data(A,M,D) :- M\=2, A>=2010, contains(M,[4,6,9,11]), D>0, D=<30.
data(A,M,D) :- M==2 , bissexto(A), A>=2010, D>0, D=<29.
data(A,M,D) :- M==2 , nao(bissexto(A)), A>=2010, D>0, D=<28.

% Extensão do predicado 'telefone': Tel => {V, F}
telefone(Tel) :- Tel >= 900000000, Tel =< 999999999.