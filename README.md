# Demonstration of a Programming Paradigm
Leonardo Fuentes Bear - A01614731

---

# Context & Description

For this evidence, I chose to solve a Codeforces problem using the Logical Paradigm with the Prolog language.

The problem I chose is 445A — DZY Loves Chessboard from Codeforces.

The problem provides an `n`×`m` board containing:

- `'.'` : empty cells
- `'-'` : blocked cells

The goal is to replace every `'.'` with either `B` (black) or `W` (white) so that every pair of adjacent non-blocked cells has different colors.

### Logical Paradigm

"The logical paradigm is a computational approach that aims to unify different areas of computing by utilizing the generality of logic" (Kowalski, 2014). It mainly consists in working with predicates formed by facts or rules, telling the program *what* needs to be true instead of *how* to compute it.

The key observation In this problem is that a chessboard alternates colors. If one cell is black, every adjacent cell must be white, and vice versa.

In the problem, blocked cells (-) can be ignored because they are never modified. Therefore, the only requirement is to assign alternating colors to every available cell (.).

This can be achieved by looking at the position of each cell. Cells where (Row + Column) is even receive B, while cells where (Row + Column) is odd receive W. This automatically produces the alternating pattern required by the problem.

---

# Model of the problem

Instead of focusing on execution, it is useful to model the board itself.

The board can be represented as a graph:

<img width="671" height="494" alt="image" src="https://github.com/user-attachments/assets/7607f0d4-9a18-42ee-9536-bdfe9c92ce98" />

Every cell is connected to its horizontal and vertical neighbors.

Notice that each cell can be classified according to:

`(Row + Column) mod 2`

Coordinates with even parity:
```
E O E
O E O
E O E
```
Possible color assignment:
```
B W B
W B W
B W B
```
Moving one position horizontally or vertically changes the value of (Row + Column) by exactly 1. Therefore, neighboring cells always have opposite parity.

By assigning color B to cells with even parity and color W to cells with odd parity, every pair of adjacent cells automatically receives different colors.

This model explains why the solution works independently of the programming language.

---

# Logic

The solution traverses the board row by row and column by column. For every position, it determines whether the cell is blocked or empty and assigns the appropriate color.

The entry predicate is:
```prolog
solve(Board, Result) :-
    color_rows(Board, 0, Result).
```
The predicate starts processing the board from row 0.

### Row Traversal

The predicate `color_rows` processes the board one row at a time:

**Base case**

When there are no rows left, the resulting board is empty:
```prolog
color_rows([], _, []).
```
**Recursive case**

Process the current row and continue with the remaining rows:

```prolog
color_rows([Row|Rows], RowIndex, [NewRow|NewRows]) :-
    color_row(Row, RowIndex, 0, NewRow),
    NextRow is RowIndex + 1,
    color_rows(Rows, NextRow, NewRows).
```
### Column Traversal

Each row is processed cell by cell using `color_row`:

**Base case**

No cells remain in the row:
```prolog
color_row([], _, _, []).
```
**Recursive case** 

Color the current cell and continue with the next column:
```prolog
color_row([Cell|Cells], Row, Col, [NewCell|NewCells]) :-
    color_cell(Cell, Row, Col, NewCell),
    NextCol is Col + 1,
    color_row(Cells, Row, NextCol, NewCells).
```

### Coloring Rules

Predicate:
```prolog
color_cell('-', _, _, '-').

color_cell('.', Row, Col, 'B') :-
    0 is (Row + Col) mod 2.

color_cell('.', Row, Col, 'W') :-
    1 is (Row + Col) mod 2.
```

For each position:

If the cell is blocked (-), leave it unchanged.
Otherwise compute (Row + Col) mod 2.
Assign B for even positions.
Assign W for odd positions.

---

## Solution Diagram

The following diagram represents the transformation model:

Input Board
```
. - .
. . .
- . -
```
Coordinates
```
(0,0) (0,1) (0,2)
(1,0) (1,1) (1,2)
(2,0) (2,1) (2,2)
```
Parity
```
0 1 0
1 0 1
0 1 0
```
Color Assignment
```
B - B
W B W
- W -
```

This diagram represents the conceptual model of the solution.

---

# References

Aguirre, B. (2025). *Lambda Calculus Functional Paradigm*. https://docs.google.com/document/d/1w8DCXQ4cQPdcDPQOVN3Hn65X000V0oixgOatseDyvUE/edit?usp=sharing

https://codeforces.com/problemset/problem/445/A

https://docs.google.com/document/d/1RMGCGPHs4aLyfOTcwZJHSzQQlBP1uJYJe72jLIdcO7g/edit?tab=t.0

Wikipedia. (2024). Codeforces. https://es.wikipedia.org/wiki/Codeforces

Kowalski, R. (2014). Logic Programming. Handbook of the History of Logic (pp. 523–569). https://doi.org/10.1016/b978-0-444-51624-4.50012-5
