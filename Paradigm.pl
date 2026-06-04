solve(Board, Result) :-
    color_rows(Board, 0, Result).

color_rows([], _, []).

color_rows([Row|Rows], RowIndex, [NewRow|NewRows]) :-
    color_row(Row, RowIndex, 0, NewRow),
    NextRow is RowIndex + 1,
    color_rows(Rows, NextRow, NewRows).

color_row([], _, _, []).

color_row([Cell|Cells], Row, Col, [NewCell|NewCells]) :-
    color_cell(Cell, Row, Col, NewCell),
    NextCol is Col + 1,
    color_row(Cells, Row, NextCol, NewCells).

color_cell('-', _, _, '-').

color_cell('.', Row, Col, 'B') :-
    0 is (Row + Col) mod 2.

color_cell('.', Row, Col, 'W') :-
    1 is (Row + Col) mod 2.
