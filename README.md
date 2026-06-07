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

# Test

I implemented 8 test cases. Two come from the Codeforces problem statement and six are additional cases:

<img width="1475" height="1078" alt="image" src="https://github.com/user-attachments/assets/b1b99f4e-addc-4220-8b97-e53a1f3d1f89" />

To run the tests in SWI-Prolog:
```prolog
swipl paradigm.pl
?- solve([['.','-','.'],['.','.','.'],[ '-','.', '-']], Result).
Result = [['B','-','B'],['W','B','W'],['-','W','-']].
```
# Time & Space Complexity

*Time complexity:* `O(n × m)` — the predicates color_rows and color_row together visit every cell of the board exactly once, performing O(1) work per cell via color_cell.

*Space complexity:* `O(n × m)` — the recursion builds the output board cell by cell, so the total space used equals the size of the board.

# Analysis 

I chose the Logical Paradigm because this problem is a natural fit for it. The solution describes what is true about each cell — blocked cells stay unchanged, empty cells receive a color determined by their parity — rather than how to compute it with loops and conditionals. Prolog's unification selects the correct clause of color_cell automatically, without any explicit branching.

The paradigm is especially useful here because:

1. Pattern matching on the cell value (`'-'` vs `'.'`) replaces explicit `if/else` chains.
2. Recursion over lists is the natural way to traverse the board in Prolog.
3. The coloring rule is expressed as a logical constraint: `0 is (Row + Col) mod 2` — Prolog either satisfies it or tries the next clause.

## Other Solutions

To present an alternative, I chose the Functional Paradigm using the Racket language. Functional programming is a paradigm rooted in lambda calculus, where computation is expressed through function application and immutable data transformations (Aguirre, 2025). It avoids shared state and side effects.
```racket
#lang racket

;; color-cell: assigns a color to a single cell
(define (color-cell cell row col)
  (cond
    [(equal? cell #\-) #\-]
    [(even? (+ row col)) #\B]
    [else #\W]))
 
;; color-row: processes a single row
(define (color-row row row-idx)
  (map (lambda (cell col) (color-cell cell row-idx col))
       row
       (build-list (length row) values)))
 
;; solve: processes the entire board
(define (solve board)
  (map (lambda (row row-idx) (color-row row row-idx))
       board
       (build-list (length board) values)))

;; Example
(solve (list (string->list ".-.")
             (string->list "...")
             (string->list "-.-")))

```

### Why I prefer Prolog for this problem

Between the two solutions, I prefer the Logical Paradigm in Prolog because the three clauses of `color_cell` map directly to the three possible situations of the problem: blocked cell, even cell, odd cell. Prolog selects the right clause through unification automatically — the code reads like a specification of the problem itself.

In Racket, I still have to think about the order of the `cond` branches and use `map` with index tracking, which is less natural for a problem that is fundamentally about declaring rules per cell. An imperative solution in Python would also work in O(n × m) but would require explicit nested loops and mutable state — less declarative than either paradigm shown here.

### Time & Space Complexity Comparison

<img width="1487" height="765" alt="image" src="https://github.com/user-attachments/assets/f5b83b52-59dc-4993-98c0-92a7be250742" />


All three paradigms achieve the same complexity. The key difference is expressiveness: Prolog declares the rules, Racket transforms the data functionally, and Python manages state imperatively.

Although, the best solution would actually be the Parallel Paradigm. Since every cell is completely independent, its color only depends on its own position `(Row + Col) mod 2`, all cells could be colored at the same time with no communication needed between threads, reducing the time to O((n × m) / p) where p is the number of processors.

---

# References

Aguirre, B. (2025). *Lambda Calculus Functional Paradigm*. https://docs.google.com/document/d/1w8DCXQ4cQPdcDPQOVN3Hn65X000V0oixgOatseDyvUE/edit?usp=sharing

https://codeforces.com/problemset/problem/445/A

https://docs.google.com/document/d/1RMGCGPHs4aLyfOTcwZJHSzQQlBP1uJYJe72jLIdcO7g/edit?tab=t.0

Kowalski, R. (2014). Logic Programming. Handbook of the History of Logic (pp. 523–569). https://doi.org/10.1016/b978-0-444-51624-4.50012-5

Learn Racket in Y Minutes. (s. f.). https://learnxinyminutes.com/es/racket/

makigas. (2014, 5 junio). Racket – 4. Listas: manipulación, iteración y recursión [Vídeo]. YouTube. https://www.youtube.com/watch?v=H3ExAU7QKt4

https://docs.google.com/document/d/1ravAZ92VzJ-xXXCrWzP6W8i9yWVWZB0MT273BVoxQvI/edit?tab=t.0
