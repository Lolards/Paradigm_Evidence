% Codeforces 445A - DZY Loves Chessboard

% Entry predicate. Takes the board as a list of lists of characters
% and returns the colored board starting from row index 0.
solve(Board, Result) :-
    color_rows(Board, 0, Result).

% Base case: no rows left, result is empty.
color_rows([], _, []).

% Recursive case: color the current row, increment the row index,
% and continue with the remaining rows.
color_rows([Row|Rows], RowIndex, [NewRow|NewRows]) :-
    color_row(Row, RowIndex, 0, NewRow),
    NextRow is RowIndex + 1,
    color_rows(Rows, NextRow, NewRows).

% Base case: no cells left in this row.
color_row([], _, _, []).

% Recursive case: color the current cell, increment the column index,
% and continue with the remaining cells.
color_row([Cell|Cells], Row, Col, [NewCell|NewCells]) :-
    color_cell(Cell, Row, Col, NewCell),
    NextCol is Col + 1,
    color_row(Cells, Row, NextCol, NewCells).

% Blocked cell, no change needed.
color_cell('-', _, _, '-').

% Empty cell at even position -> Black.
% (Row + Col) mod 2 = 0 means neighboring cells will be odd -> White.
color_cell('.', Row, Col, 'B') :-
    0 is (Row + Col) mod 2.

% Empty cell at odd position -> White.
% (Row + Col) mod 2 = 1 means neighboring cells will be even -> Black.
color_cell('.', Row, Col, 'W') :-
    1 is (Row + Col) mod 2.
