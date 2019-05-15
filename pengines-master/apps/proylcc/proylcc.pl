:- module(proylcc,
	[  
		emptyBoard/1,
		goMove/4,
		terminarJuego/3
	]).

emptyBoard([
		 ["-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-"],
		 ["-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-"],
		 ["-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-"],
		 ["-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-"],
		 ["-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-"],
		 ["-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-"],
		 ["-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-"],
		 ["-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-"],
		 ["-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-"],
		 ["-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-"],
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
	adyacentes(RBoard, R, C,ListaAdyacentes),
	encerradosContrario(RBoard, Player, R, C,ListaAdyacentes, [[Player,R,C]], ListaEncerradosContrarios),
	eliminarEncerrados(RBoard, ListaEncerradosContrarios, NBoard),
	adyacentes(NBoard, R, C, NListaAdyacentes),
	\+(encerrados(NBoard, Player, R, C, NListaAdyacentes, [[Player,R,C]], _ListaEncerrados)).

goMove(Board, Player, [R,C], RBoard):-
    replace(Row, R, NRow, Board, RBoard),
    replace("-", C, Player, Row, NRow),
	adyacentes(RBoard, R, C,ListaAdyacentes),
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

obtenerAdyacente(_Board, 19, _Columna, []).
obtenerAdyacente(_Board, -1, _Columna, []).
obtenerAdyacente(_Board, _Fila, 19, []).
obtenerAdyacente(_Board, _Fila, -1, []).
obtenerAdyacente(_Board, 19, 19, []).
obtenerAdyacente(_Board, -1, -1, []).
obtenerAdyacente(Board, Fila, Columna, [[Ficha,Fila,Columna]]):-
	Fila \= 19,
	Fila \= -1,
	Columna \= 19,
	Columna \= -1,
	getElem(F, Fila, Board), 
	getElem(Ficha, Columna, F).

adyacentes(Board, Fila, Columna, Adyacentes):-
	IndexArriba is Fila - 1, IndexAbajo is Fila + 1, IndexDerecha is Columna + 1, IndexIzquierda is Columna - 1,
	obtenerAdyacente(Board, IndexArriba, Columna, FichaArriba),
	obtenerAdyacente(Board, IndexAbajo, Columna, FichaAbajo),
	obtenerAdyacente(Board, Fila, IndexIzquierda, FichaIzquierda),
	obtenerAdyacente(Board, Fila, IndexDerecha, FichaDerecha),
	append(FichaArriba,FichaAbajo,ArribaAbajo),
	append(FichaIzquierda,FichaDerecha,IzquierdaDerecha),
	append(ArribaAbajo,IzquierdaDerecha,Adyacentes).

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
	adyacentes(Board, RAd, CAd, RAdyacentes),
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
	adyacentes(Board, RAd, CAd, AdyacentesAd),
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
	adyacentes(Board, RAd, CAd, RAdyacentes),
	encerradosVacios(Board, Vacio, Player, RAd, CAd, RAdyacentes, [[Vacio,RAd,CAd]|Vistos], EncerradosAd),
	append(Vistos, EncerradosAd, VistosAux),
	encerradosVacios(Board, Vacio, Player, R, C, Adyacentes, VistosAux ,EncerradosP),
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

obtenerTernas(_Fila, _F, -1, []).

obtenerTernas(Fila, F, Index, [[Ficha,F,Index]|Lista]):-
	IndexAux is Index -1,
	getElem(Ficha, Index, Fila),
	Ficha = "-",
	obtenerTernas(Fila, F, IndexAux, Lista).

obtenerTernas(Fila, F, Index, Lista):-
	IndexAux is Index -1,
	obtenerTernas(Fila, F, IndexAux, Lista).

terminarJuego(Board, PuntosW, PuntosB):-
	aplanarVacios(Board, 18, Vacios),
	contarPuntos(Board, "b", Vacios, [], EncerradosB),
	contarPuntos(Board, "w", Vacios, [], EncerradosW),
	length(EncerradosB, PuntosB),
	length(EncerradosW, PuntosW).

%Caso base: No me quedan vacios por revisar
contarPuntos(_Board, _Player, [], _Vistos, []).

%Caso recursivo 1: El siguiente Vacio por revisar todavia no lo visité, y reviso si esta encerrado y si lo está sigo con los demas
contarPuntos(Board, Player, [["-",F,C]|Vacios], Vistos, ListaEncerradosTerreno):-
	\+(member(["-",F,C], Vistos)),
	adyacentes(Board, F, C, Adyacentes),
	encerradosVacios(Board, "-", Player, F, C, Adyacentes, [["-",F,C]], EncerradosTerreno),
	append(Vistos, EncerradosTerreno, EncerradosVistos),
	contarPuntos(Board, Player, Vacios, [["-",F,C]|EncerradosVistos], Encerrados),
	append(Encerrados, EncerradosTerreno, ListaEncerradosTerreno).

%Caso recursivo 2: El siguiente en la lista ya fue revisado, O no esta encerrado
contarPuntos(Board, Player, [["-",F,C]|Vacios], Vistos, ListaEncerradosTerreno):-
	contarPuntos(Board, Player, Vacios, [["-",F,C]|Vistos], ListaEncerradosTerreno).