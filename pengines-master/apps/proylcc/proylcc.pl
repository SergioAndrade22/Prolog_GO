:- module(proylcc,
	[  
		emptyBoard/1,
		goMove/4
	]).

emptyBoard([
		 ["-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-"],
		 ["-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-"],
		 ["-","-","-","b","b","-","-","-","-","-","-","-","-","-","-","-","-","-","-"],
		 ["-","-","b","-","-","b","-","-","-","-","-","-","-","-","-","-","-","-","-"],
		 ["-","-","-","b","b","-","-","-","-","-","-","-","-","-","-","-","-","-","-"],
		 ["-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-"],
		 ["-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-"],
		 ["-","-","-","-","-","-","-","-","-","w","-","-","-","-","-","-","-","-","-"],
		 ["-","-","-","-","-","-","-","-","w","-","w","-","-","-","-","-","-","-","-"],
		 ["-","-","-","-","-","-","-","-","-","w","-","-","-","-","-","-","-","-","-"],
		 ["-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-"],
		 ["-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-"],
		 ["-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-"],
		 ["-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-"],
		 ["-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-"],
		 ["-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-"],
		 ["-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-"],
		 ["-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-"],
		 ["-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-"]
		 ]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% goMove(+Board, +Player, +Pos, -RBoard)
% 
% RBoard es la configuración resultante de reflejar la movida del jugador Player
% en la posición Pos a partir de la configuración Board.

goMove(Board, Player, [R,C], NBoard):-
	replace(Row, R, NRow, Board, RBoard),
    replace("-", C, Player, Row, NRow),
	adyacentes(RBoard,Player, R, C,ListaAdyacentes),
	encerradosContrario(RBoard, Player, R, C,ListaAdyacentes, [[Player,R,C]], ListaEncerradosContrarios),
	eliminarEncerrados(RBoard, ListaEncerradosContrarios, NBoard),
	adyacentes(NBoard, Player, R, C, NListaAdyacentes),
	\+(encerrados(NBoard, Player, R, C, NListaAdyacentes, [[Player,R,C]], _ListaEncerrados)).

goMove(Board, Player, [R,C], RBoard):-
    replace(Row, R, NRow, Board, RBoard),
    replace("-", C, Player, Row, NRow),
	adyacentes(RBoard,Player, R, C,ListaAdyacentes),
	\+(encerrados(RBoard, Player, R, C, ListaAdyacentes, [[Player,R,C]], _ListaEncerrados)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% replace(?X, +XIndex, +Y, +Xs, -XsY)
%

replace(X, 0, Y, [X|Xs], [Y|Xs]).

replace(X, XIndex, Y, [Xi|Xs], [Xi|XsY]):-
    XIndex > 0,
    XIndexS is XIndex - 1,
    replace(X, XIndexS, Y, Xs, XsY).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Mediante la consulta opPlayer(+X, ?Y) permite saber si cual es el jugador opuesto a X

opPlayer("w", "b").
opPlayer("b", "w").

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Metodo recursivo que permite eliminar los elementos presentes en una lista del tablero
%	eliminar (+Board, +AEliminar, ?NBoard)

eliminarEncerrados(Board, [], Board).

eliminarEncerrados(Board, [[Ficha, Fila, Columna]|AEliminar], NBoard):-
    replace(Row, Fila, NRow, Board, RBoard),
    replace(Ficha, Columna, "-", Row, NRow),
    eliminarEncerrados(RBoard, AEliminar, NBoard).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Perimite obtener una lista conteniendo todos los adyacentes de una posicion dada
%	
adyacentes(Board, Player, Fila, Columna, [[FichaArriba, IndexArriba, Columna], [FichaAbajo, IndexAbajo, Columna], [FichaDerecha, Fila, IndexDerecha], [FichaIzquierda, Fila, IndexIzquierda]]):-
	IndexArriba is Fila - 1, IndexAbajo is Fila + 1, IndexDerecha is Columna + 1, IndexIzquierda is Columna - 1,
	%Obtiene la ficha adyacente arriba
	((IndexArriba < 0 , opPlayer(Player, FichaArriba));
		(getElem(FilaArriba, IndexArriba, Board), getElem(FichaArriba, Columna, FilaArriba))),
	%Obtiene la ficha adyacente abajo
	((IndexAbajo > 18, opPlayer(Player, FichaAbajo));
		(getElem(FilaAbajo, IndexAbajo, Board), getElem(FichaAbajo, Columna, FilaAbajo))),
	%%Obtiene la fila actual
	getElem(FilaActual, Fila, Board),
	%Obtiene la ficha adyacente derecha
	((IndexDerecha > 18, opPlayer(Player, FichaDerecha));
		getElem(FichaDerecha, IndexDerecha, FilaActual)),
	%Obtiene la ficha adyacente izquierda
	((IndexIzquierda < 0, opPlayer(Player, FichaIzquierda));
		getElem(FichaIzquierda, IndexIzquierda, FilaActual)).

getElem(X, 0, [X|_Xs]).

getElem(X, XIndex, [_Xi|Xs]):-
    XIndex > 0,
    XIndexS is XIndex - 1,
    getElem(X, XIndexS, Xs).

%%Encerrados Tomi
%Caso Base, cuando no quedan mas adyacentes por revisar, asumo que estoy encerrado
encerrados(_Board, Player, R, C, [], _Vistos, [[Player,R,C]]).

%Caso recursivo, donde el siguiente adyacente es del mismo color, chequeo si esta encerrado y sus adyacentes, y reviso el resto de mis adyacentes
encerrados(Board, Player, R, C, [[Player, RAd, CAd]|Adyacentes], Vistos, Encerrados):-
	\+(member([Player, RAd, CAd], Vistos)),
	adyacentes(Board, Player, RAd, CAd, RAdyacentes),
	encerrados(Board, Player, RAd, CAd, RAdyacentes, [[Player,RAd,CAd]|Vistos], EncerradosAd),
	append([[Player,RAd,CAd]|Vistos], EncerradosAd, VistosAux),
	encerrados(Board, Player, R, C, Adyacentes, VistosAux,EncerradosP),
	append(EncerradosP,EncerradosAd,Encerrados).

%Caso recursivo, donde el siguiente adyacente es del mismo color, pero ya lo revisé, sigo con los demas adyacentes
encerrados(Board, Player, R, C, [[Player, RAd, CAd]|Adyacentes], Vistos, Encerrados):-
	member([Player, RAd, CAd],Vistos),
	encerrados(Board, Player, R, C, Adyacentes, Vistos, Encerrados).
	
%Caso recursivo, donde el siguiente adyacente es del color opuesto, chequeo los demas adyacentes
encerrados(Board, Player, R, C, [[Player2, _RAd, _CAd]|Adyacentes], Vistos, Encerrados):-
	Player2 \= Player,
	Player2 \= "-",
	encerrados(Board, Player, R, C, Adyacentes, Vistos, Encerrados).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Caso base, no me quedan adyacentes por revisar
encerradosContrario(_Board, _Player, _R, _C, [], _Vistos, []).

%Caso recursivo 1, adyacente no es del color opuesto, lo salteo
encerradosContrario(Board, Player, R, C, [[Player, _RAd, _CAd]|Adyacentes], Vistos, Encerrados):-
	encerradosContrario(Board, Player, R, C, Adyacentes, Vistos, Encerrados).

%Caso recursivo 1 bis, adyacente no es del color opuesto, lo salteo
encerradosContrario(Board, Player, R, C, [["-", _RAd, _CAd]|Adyacentes], Vistos, Encerrados):-
	encerradosContrario(Board, Player, R, C, Adyacentes, Vistos, Encerrados).

%Caso recursivo 2, adyacente es del color opuesto y ya lo visité, lo salteo
encerradosContrario(Board, Player,R,C,[[Ficha, RAd, CAd]|Adyacentes], Vistos, Encerrados):-
	Ficha \= Player,
	Ficha \= "-",
	member([Player, RAd, CAd],Vistos),
	encerradosContrario(Board, Player, R, C, Adyacentes, Vistos, Encerrados).

%Caso recursivo 3, adyacente es del color opuesto pero no lo visité, miro si esta encerrado y paso al siguiente adyacente
encerradosContrario(Board, Player, R, C, [[Ficha, RAd, CAd]|Adyacentes], Vistos, Encerrados):-
	Ficha \= Player,
	Ficha \= "-",
	adyacentes(Board, Ficha, RAd, CAd, AdyacentesAd),
	encerrados(Board, Ficha, RAd, CAd, AdyacentesAd, [[Ficha, RAd, CAd]], Encerrados1),
	append(Encerrados1, Vistos, NuevosVistos),
	encerradosContrario(Board, Player, R, C, Adyacentes, [[Ficha, RAd, CAd]|NuevosVistos], Encerrados2),
	append(Encerrados1, Encerrados2, Encerrados).
	
%Caso recursivo 3 bis, adyacente es del color opuesto pero no lo visité y ya se que no está encerrado, miro si esta encerrado y paso al siguiente adyacente
encerradosContrario(Board, Player, R, C, [[Ficha, RAd, CAd]|Adyacentes], Vistos, Encerrados):-
	Ficha \= Player,
	Ficha \= "-",
	encerradosContrario(Board, Player, R, C, Adyacentes, [[Ficha, RAd, CAd]|Vistos], Encerrados).

%Caso Base, cuando no quedan mas adyacentes por revisar, asumo que estoy encerrado
encerradosVacios(_Board, Vacio, _Player, R, C, [], _Vistos, [[Vacio,R,C]]).

encerradosVacios(Board, Vacio, Player, R, C, [[Vacio, RAd, CAd]|Adyacentes], Vistos, Encerrados):-
	\+(member([Vacio, RAd, CAd], Vistos)),
	adyacentes(Board, Vacio, RAd, CAd, RAdyacentes),
	encerradosVacios(Board, Vacio, Player, RAd, CAd, RAdyacentes, [[Vacio,RAd,CAd]|Vistos], EncerradosAd),
	append([[Vacio,RAd,CAd]|Vistos], EncerradosAd, VistosAux),
	encerradosVacios(Board, Vacio, Player, R, C, Adyacentes, VistosAux,EncerradosP),
	append(EncerradosP,EncerradosAd,Encerrados).

encerradosVacios(Board, Vacio, Player, R, C, [[Vacio, RAd, CAd]|Adyacentes], Vistos, Encerrados):-
	member([Vacio, RAd, CAd],Vistos),
	encerradosVacios(Board, Vacio, Player, R, C, Adyacentes, Vistos, Encerrados).
	
encerradosVacios(Board, Vacio, Player, R, C, [[Player, _RAd, _CAd]|Adyacentes], Vistos, Encerrados):-
	Vacio \= Player,
	encerradosVacios(Board, Vacio,Player, R, C, Adyacentes, Vistos, Encerrados).

aplanarVacios(_Board, -1, []).

aplanarVacios(Board, F, Lista) :-
	FAux is F - 1,
	aplanarVacios(Board, FAux, ListaListas),
	getElem(Fila, F, Board),
	obtenerTernas(Fila,F,18,ListaTernas),
	append(ListaListas,ListaTernas,Lista).

obtenerTernas(_Fila,_F,-1,[]).

obtenerTernas(Fila,F,Index,[[Ficha,F,Index]|Lista]):-
	IndexAux is Index -1,
	getElem(Ficha,Index,Fila),
	Ficha = "-",
	obtenerTernas(Fila,F,IndexAux,Lista).

obtenerTernas(Fila,F,Index,Lista):-
	IndexAux is Index -1,
	obtenerTernas(Fila,F,IndexAux,Lista).

terminarJuego(Board,PuntosW,PuntosB):-
	aplanarVacios(Board,18,Vacios),
	contarPuntos(Board,"b",Vacios,[],EncerradosB),
	contarPuntos(Board,"w",Vacios,[],EncerradosW),
	length(EncerradosB,PuntosB),
	length(EncerradosW,PuntosW).

contarPuntos(_Board,_Player,[],_Vistos,[]).

contarPuntos(Board,Player,[["-",F,C]|Vacios],ListaEncerradosTerreno):-
	adyacentes(Board, "-", F, C, Adyacentes),
	encerradosVacios(Board, F, C, "-",Player, Adyacentes,[["-",F,C]|Vistos], EncerradosTerreno),
	append(Vistos,EncerradosTerreno,EncerradosVistos),
	contarPuntos(Board,Player,Vacios,[["-",F,C]|EncerradosVistos],Encerrados),
	append(Encerrados,EncerradosTerreno,ListaEncerradosTerreno).