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

goMove(Board, Player, [R,C], RRBoard):-
    replace(Row, R, NRow, Board, RBoard),
    replace("-", C, Player, Row, NRow),
	adyacentes(RBoard, Player, R, C, ListaAdyacentes),
	adyacentesEncerrados(Board, ListaAdyacentes, EncerradosAEliminar),
	eliminarEncerrados(RBoard, EncerradosAEliminar, RRBoard),
    %Verifica el suicidio
	\+(encerrados(RBoard, Player, R, C,ListaAdyacentes, [[Player,R,C]], ListaEncerrados)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% replace(?X, +XIndex, +Y, +Xs, -XsY)
%

eliminarEncerrados(Board, [], NBoard).

eliminarEncerrados(Board, [[Ficha, Fila, Columna]|AEliminar], NBoard):-
    replace(Row, Fila, NRow, Board, RBoard),
    replace("-", Columna, Ficha, Row, NRow),
    eliminarEncerrados(RBoard, AEliminar, NBoard).
	

adyacentesEncerrados(Board, [], NuevosEncerrados).

adyacentesEncerrados(Board, [[Ficha, Fila, Columna]|Adyacentes], NuevosEncerrados):-
	adyacentes(Board, Ficha, Fila, Columna, SiguientesAdyacentes),
	encerrados(Board, Ficha, Fila, Columna, SiguientesAdyacentes, [Ficha, Fila, Columna], NuevosEncerrados),
	adyacentesEncerrados(Board, Adyacentes, NuevosEncerrados).

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

getElem(X, 0, [X|Xs]).

getElem(X, XIndex, [Xi|Xs]):-
    XIndex > 0,
    XIndexS is XIndex - 1,
    getElem(X, XIndexS, Xs).

%Caso Base, cuando no quedan mas adyacentes por revisar, asumo que estoy encerrado
encerrados(Board,Player,R,C,[],Vistos,[[Player,R,C]]).

%Caso recursivo, donde el siguiente adyacente es del mismo color, chequeo si esta encerrado y sus adyacentes, y reviso el resto de mis adyacentes
encerrados(Board,Player,R,C,[[Player, RAd, CAd]|Adyacentes],Vistos,[[Player,R,C]|Encerrados]):-
	\+(member([Player, RAd, CAd],Vistos)),
	adyacentes(Board,Player,R,C,RAdyacentes),
	encerrados(Board,Player,RAd,CAd,RAdyacentes,[[Player,R,C]|Vistos],EncerradosAd),
	encerrados(Board,Player,R,C,Adyacentes,[[Player,R,C]|Vistos],EncerradosP),
	append(EncerradosP,EncerradosAd,Encerrados).

%Caso recursivo, donde el siguiente adyacente es del mismo color, pero todavía ya lo revisé, sigo con los demas adyacentes
encerrados(Board,Player,R,C,[[Player, RAd, CAd]|Adyacentes],Vistos,[[Player,R,C]|Encerrados]):-
	member([Player, RAd, CAd],Vistos),
	encerrados(Board,Player,R,C,Adyacentes,[[Player,R,C]|Vistos],Encerrados).
	
%Caso recursivo, donde el siguiente adyacente es del color opuesto, chequeo los demas adyacentes
encerrados(Board,Player,R,C,[[Player2, RAd, CAd]|Adyacentes],Vistos,Encerrados):-
	Player2 \= Player,
	Player2 \= "-",
	encerrados(Board,Player,R,C,Adyacentes,Vistos,Encerrados).