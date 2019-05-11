:- module(proylcc,
	[  
		emptyBoard/1,
		goMove/4
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
	adyacentes(RBoard,Player, R, C,ListaAdyacentes),
	encerradosContrario(RBoard, Player, R, C,ListaAdyacentes, [[Player,R,C]], ListaEncerradosContrarios),
	eliminarEncerrados(RBoard, ListaEncerradosContrarios, NBoard).

goMove(Board, Player, [R,C], RBoard):-
    replace(Row, R, NRow, Board, RBoard),
    replace("-", C, Player, Row, NRow),
	adyacentes(RBoard,Player, R, C,ListaAdyacentes),
	\+(encerrados(RBoard, Player, R, C, ListaAdyacentes, [[Player,R,C]], _ListaEncerrados)).
	%encerradosContrario(RBoard, Player, R, C,ListaAdyacentes, [[Player,R,C]], ListaEncerradosContrarios).
	%eliminarEncerrados(RBoard,ListaEncerradosContrarios,NBoard).
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% replace(?X, +XIndex, +Y, +Xs, -XsY)
%

replace(X, 0, Y, [X|Xs], [Y|Xs]).

replace(X, XIndex, Y, [Xi|Xs], [Xi|XsY]):-
    XIndex > 0,
    XIndexS is XIndex - 1,
    replace(X, XIndexS, Y, Xs, XsY).

opPlayer("w", "b").
opPlayer("b", "w").
	
%Adyacentes tomi
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
encerrados(Board, Player, R, C, [[Player, RAd, CAd]|Adyacentes], Vistos, [[Player,R,C]|Encerrados]):-
	\+(member([Player, RAd, CAd], Vistos)),
	adyacentes(Board, Player, RAd, CAd, RAdyacentes),
	encerrados(Board, Player, RAd, CAd, RAdyacentes, [[Player,R,C]|Vistos], EncerradosAd),
	append(Vistos, EncerradosAd, VistosAux),
	encerrados(Board, Player, R, C, Adyacentes, [[Player,R,C]|VistosAux],EncerradosP),
	append(EncerradosP,EncerradosAd,Encerrados).

%Caso recursivo, donde el siguiente adyacente es del mismo color, pero ya lo revisé, sigo con los demas adyacentes
encerrados(Board, Player, R, C, [[Player, RAd, CAd]|Adyacentes], Vistos, [[Player,R,C]|Encerrados]):-
	member([Player, RAd, CAd],Vistos),
	encerrados(Board, Player, R, C, Adyacentes, Vistos, Encerrados).
	
%Caso recursivo, donde el siguiente adyacente es del color opuesto, chequeo los demas adyacentes
encerrados(Board, Player, R, C, [[Player2, _RAd, _CAd]|Adyacentes], Vistos, Encerrados):-
	Player2 \= Player,
	Player2 \= "-",
	encerrados(Board, Player, R, C, Adyacentes, Vistos, Encerrados).

%%EncerradosContrarios Hecho por tomi, no termina de funcionar
%Caso base, no me quedan adyacentes por revisar
encerradosContrario(_Board, _Player, _R, _C, [], _Vistos, []).

%Caso recursivo 1, adyacente no es del color opuesto, lo salteo
encerradosContrario(Board, Player, R, C, [[Player, _RAd, _CAd]|Adyacentes], Vistos, Encerrados):-
	encerradosContrario(Board,Player,R,C,Adyacentes,Vistos,Encerrados).

%Caso recursivo 2, adyacente es del color opuesto y ya lo visité, lo salteo
encerradosContrario(Board,Player,R,C,[[Ficha, RAd, CAd]|Adyacentes],Vistos,Encerrados):-
	Ficha \= Player,
	Ficha \= "-",
	member([Player, RAd, CAd],Vistos),
	encerradosContrario(Board,Player,R,C,Adyacentes,Vistos, Encerrados).

%Caso recursivo 3, adyacente es del color opuesto pero no lo visité, miro si esta encerrado y paso al siguiente adyacente
encerradosContrario(Board, Player, R, C, [[Ficha, RAd, CAd]|Adyacentes], Vistos, Encerrados):-
	Ficha \= Player,
	Ficha \= "-",
	adyacentes(Board, Ficha, RAd, CAd, AdyacentesAd),
	encerrados(Board, Ficha, RAd, CAd, AdyacentesAd, [[Ficha, RAd, CAd]|Vistos], Encerrados1),
	append(EncerradosAd, Vistos, NuevosVistos),
	encerradosContrario(Board, Player, R, C, Adyacentes, [[Ficha, RAd, CAd]|NuevosVistos], Encerrados2),
	append(Encerrados1, Encerrados2, Encerrados).
	
%Caso recursivo 3 bis, adyacente es del color opuesto pero no lo visité y ya se que no está encerrado, miro si esta encerrado y paso al siguiente adyacente
encerradosContrario(Board, Player, R, C, [[Ficha, RAd, CAd]|Adyacentes], Vistos, Encerrados):-
	Ficha \= Player,
	Ficha \= "-",
	adyacentes(Board, Ficha, RAd, CAd, AdyacentesAd),
	encerradosContrario(Board, Player, R, C, Adyacentes, [[Ficha, RAd, CAd]|Vistos], Encerrados).

eliminarEncerrados(Board, [], Board).

eliminarEncerrados(Board, [[Ficha, Fila, Columna]|AEliminar], NBoard):-
    replace(Row, Fila, NRow, Board, RBoard),
    replace(Ficha, Columna, "-", Row, NRow),
    eliminarEncerrados(RBoard, AEliminar, NBoard).