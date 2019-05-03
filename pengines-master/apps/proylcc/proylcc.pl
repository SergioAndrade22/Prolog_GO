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

goMove(Board, Player, [R,C], RBoard):-
    replace(Row, R, NRow, Board, RBoard),
    replace("-", C, Player, Row, NRow),
    \+(encerrado(RBoard, Player, R, C, [], X)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% replace(?X, +XIndex, +Y, +Xs, -XsY)
%

replace(X, 0, Y, [X|Xs], [Y|Xs]).

replace(X, XIndex, Y, [Xi|Xs], [Xi|XsY]):-
    XIndex > 0,
    XIndexS is XIndex - 1,
    replace(X, XIndexS, Y, Xs, XsY).

%Caso base, funca 
encerrado(Board, Player, R, C, Encerradas, [[Player, R, C]|Encerradas]):-
	adyacentes(Board, R, C, [FichaArriba, IndexArriba, Columna], [FichaAbajo, IndexAbajo, Columna], [FichaDerecha, Fila, IndexDerecha], [FichaIzquierda, Fila, IndexIzquierda]),
	((FichaArriba \= Player, FichaArriba \= "-") ; member([FichaArriba, IndexArriba, Columna], Encerradas)),
	((FichaAbajo \= Player, FichaAbajo \= "-") ; member([FichaAbajo, IndexAbajo, Columna], Encerradas)),
	((FichaDerecha \= Player, FichaDerecha \= "-") ; member([FichaDerecha, Fila, IndexDerecha], Encerradas)),
	((FichaIzquierda \= Player, FichaIzquierda \= "-") ; member([FichaIzquierda, Fila, IndexIzquierda], Encerradas)).


%%Encerrados Tomi
%Caso Base, cuando no quedan mas adyacentes por revisar, asumo que estoy encerrado
encerrados(Board,Player,R,C,[],Vistos,[[Player,R,C]]).

%Caso recursivo, donde el siguiente adyacente es del mismo color, chequeo si esta encerrado y sus adyacentes, y reviso el resto de mis adyacentes
encerrados(Board,Player,R,C,[[Player, RAd, CAd]|Adyacentes],Vistos,[[Player,R,C]|Encerrados]):-
	\+(member([Player, RAd, CAd],Vistos)),
	adyacentes(Board,R,C,RAdyacentes),
	encerrados(Board,Player,RAd,CAd,RAdyacentes,[[Player,R,C]|Vistos],EncerradosAd,),%No se que tan legal es hacer meter [[Player,R,C]|Vistos]
	encerrados(Board,Player,R,C,Adyacentes,[[Player,R,C]|Vistos],EncerradosP),
	append(EncerradosP,EncerradosAd,Encerrados).
	
%Caso recursivo, donde el siguiente adyacente es del color opuesto, chequeo los demas adyacentes
encerrados(Board,Player,R,C,[[Player2, RAd, CAd]|Adyacentes],Vistos,Encerrados):-
	Player2 \= Player,
	Player2 \= "-",
	encerrados(Board,Player,R,C,Adyacentes,Vistos,Encerrados).
	

adyacentes(Board, Fila, Columna, [FichaArriba, IndexArriba, Columna], [FichaAbajo, IndexAbajo, Columna], [FichaDerecha, Fila, IndexDerecha], [FichaIzquierda, Fila, IndexIzquierda]):-
	IndexArriba is Fila - 1, IndexAbajo is Fila + 1, IndexDerecha is Columna + 1, IndexIzquierda is Columna - 1,
	%Obtiene la ficha adyacente arriba
	getElem(FilaArriba, IndexArriba, Board),
	getElem(FichaArriba, Columna, FilaArriba),
	%Obtiene la ficha adyacente abajo
	getElem(FilaAbajo, IndexAbajo, Board),
	getElem(FichaAbajo, Columna, FilaAbajo),
	%%Obtiene la fila actual
	getElem(FilaActual, Fila, Board),
	%Obtiene la ficha adyacente derecha
	getElem(FichaDerecha, IndexDerecha, FilaActual),
	%Obtiene la ficha adyacente izquierda
	getElem(FichaIzquierda, IndexIzquierda, FilaActual).

getElem(X, 0, [X|Xs]).

getElem(X, XIndex, [Xi|Xs]):-
    XIndex > 0,
    XIndexS is XIndex - 1,
    getElem(X, XIndexS, Xs).
