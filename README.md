# IT duel 2016 at Anadea inc.

Epic win! :)

The challenge format - single creative problem, seven 4-max teams, 4 hours for solving.

The winner team:
* Sergey Tokarenko  - [LinkedIn](https://www.linkedin.com/in/stokarenko), [GitHub](https://github.com/stokarenko)
* Dmitriy Kiriyenko - [LinkedIn](https://ua.linkedin.com/in/kiriyenko), [GitHub](https://github.com/dmitriy-kiriyenko)
* Alexey Kudryashov - [LinkedIn](https://www.linkedin.com/in/alexey-kudryashov-27321056), [GitHub](https://github.com/KudryashovAV)

![](images/epic_win.jpg)

## The problem
The problem is about [the Tetris game](https://en.wikipedia.org/wiki/Tetris).
Need to compile the square N*N (4 <= N <= 50) from the given set of [tetromino figures](https://en.wikipedia.org/wiki/Tetromino).
The figures can rotate.

![](images/example.png)

In general, you are given:
```ruby
{
  size: N,
  signature: "#{FIGURE_1_ID}#{FIGURE_1_QUANTITY},...,#{FIGURE_M_ID}#{FIGURE_M_QUANTITY}"
}
```

The solution should looks like:
```ruby
[
  [FIGURE_ID, ANGLE_ID, X_1, Y_1],
  ...,
  [FIGURE_ID, ANGLE_ID, X_I, Y_I]
]
```
X and Y are top-left corner coordinates of placed figure, both starting from 0.

Figure IDs and angle IDs should correspond to the definition:
![](images/figures.png)

## API

Take the task:  
```
  URL: "http://tetro.andy128k.net/api/puzzle"
  HTTP method: `GET`
```

Required parameters:
* token - unique team identifier;
* size - foursquare(task) size;

Example:
```console
  $ curl --request GET "http://tetro.andy128k.net/api/puzzle?token=57492ce2-e312-4c80-b131-37be4031f30e&size=4"

  >> {"id":123116,"size":4,"signature":"I1,J1,L1,Z1"}
```

Send the solution:
```
  URL: "http://tetro.andy128k.net/api/puzzle"
  HTTP method: `POST`
```

Required parameters:
* token - unique token of your command;
* id - task id;
* solution - task solution;

Example:
```console
  $ curl --request POST --data "token=57492ce2-e312-4c80-b131-37be4031f30e&id=123116&solution=[[\"L\",1,0,0],[\"S\",0,0,1],[\"L\",1,3,0],[\"S\",0,1,2]]" http://tetro.andy128k.net/api/puzzle

  >> {"id":123116,"solved":true,"submitted_at":"2015-12-12 12:12:12Z"}
```

## Winner ideas
There are just three ones:

1. Avoid the ado around `Where to place the figure?`.
   Instead, our target is to fill each cell of the board, one by one.

2. Avoid the ado around the figure structure and rotations via bit masks.
   Board is not the N*N array as well, but an Integer compiled from N*N bits.
   In additional, start not from empty N*N board, but from (N+2)*(N+2) one, with a border -
   that helps us to avoid the ado around `Is the figure inside the board still?` and
   `Is the figure's bit mask applied without infliction with the board edges?`

3. Compile the tree, where vertex is concrete board filling (starting from empty board),
   and edges represent the Figure & Angle pairs which can fill the next empty cell of board.
   Try to find the way from root `empty board` node to `fully filled board` node
   via [Depth-first search](https://en.wikipedia.org/wiki/Depth-first_search)

Thats all - no any kind of connectivity checks, no any programming ado  =)
So simple to implement within 4 hours, so effective to get a win :)
The sources of that solution are marked by [v0.0.1](https://github.com/stokarenko/it-duel-2016/tree/v0.0.1) tag.

## Ultimate ideas
The `Ultimate` solution lives in [master](https://github.com/stokarenko/it-duel-2016) branch.
It is natural evolution of winner one, bust extended by several key ideas. Such as...

### Balanced Blocks Container !
Lives in `lib/tetris/balanced_blocks_container.rb`

When we thinking what to do with the next empty board position -
try to place the figure types ordered by their remaining quantity, descending.

That helps us to reach the bottom of [DFS stack](https://github.com/stokarenko/it-duel-2016/blob/master/lib/tetris/solver.rb#L51)
with a single figure by each type, more or less.

### Diagonal Position Strategy !!
Lives in `lib/tetris/diagonal_position_strategy.rb`, `next` method.

Lets say that we have a board with numbered cells:
```
 0  1  2  3
 4  5  6  7
 8  9 10 11
12 13 14 15
```

In winner solution we iterated the board cells one after one, linearly:
```ruby
[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15].each{}
```

That causes the long N*(1 || 2) pathologic cell lines at the bottom of DFS stack,
and turns DFS to infinity loop mode on large board sizes :)

Lets walk through the board by diagonals:
```ruby
[
  0,
  1,4,
  2,5,8,
  3,6,9,12,
  7,10,13,
  11,14,
  15
].each{}
```

Now at the bottom of DFS stack we have a small pyramid
(with top at the board's right-bottom corner).

`DiagonalPositionStrategy` & `BalancedBlocksContainer` synergy gives us the brilliant
situation, when any task on any board size aims to become the same small problem.
And we already know how to deal with this problem.

Now the remaining goal is to reach the bottom of stack as fast as possible. How to do that?..

### Connectivity !!!
Lives in `lib/tetris/connectivity.rb`.

Don't allow to apply the figure, which isolates the empty cells.
How to do that?

We hate any kind of ado, still and forever.
We will try to avoid it until we can.
We don't want to look for isolated empty cells though whole board.

But at any moment we know how many figures already applied.
And we know that any figure covers exactly 4 cells.
And we know the next empty (guaranted) board cell.

Lets calculate the count of connected empty cells starting from such empty cell,
via [Breadth-first search](https://en.wikipedia.org/wiki/Breadth-first_search).

Easy to see that this count must equal to `SIZE ** 2 - APPLIED_FIGURES_COUNT * 4`
when there is no any isolated empty cells.

Currently, we are too lazy even for this, and
[checking only division by 4](https://github.com/stokarenko/it-duel-2016/blob/master/lib/tetris/connectivity.rb#L20)
Actually that can cause the pathologic situation, but the chance is quite small -
thanks to `DiagonalPositionStrategy`.

As a lucky bonus, notice that general computing work is going to be done
at the bottom of DFS stack
(we are doing our best to dive to the bottom dashingly),
so the empty cells connectivity subroutine will take almost nothing there,
due to the lack of empty cells =)

And, the last one...

### Pathologies !!!!
Lets cure some pathologic situations.

First of them looks like:
```
  @ @ @ @ @
  @ @ @   @
  @ @ @   @
  @        
  @ @ @
```
There is no any figure which can be applied within.
Lets ban this situation.

Each time when the figure is applied, lets look for this configuration
through the whole board...

A-ha, no way! Ago, lazy - do you remember? )

How this situation appears? Remember `DiagonalPositionStrategy`,
we are walking from top-right to bottom-left. Easy to see, that pathologic combination
appears, right when we apply the `J` figure:
```
  @ @ @ @ @
  @ @ @   @
  @ @ @   @
  !        
  ! ! !
```

Is it all the cases? Think a bit..
Ya, `I` figure can compile the pathologic as well:
```
  @ @ @ @ @
  @ @ @   @
  @ @ @   @
  @        
! ! ! !
```

Lets [implement](https://github.com/stokarenko/it-duel-2016/blob/master/lib/tetris/diagonal_position_strategy.rb#L26) that trick.

The second pathologic situation looks like:
```
  @ @ @ @ @
  @ @ @   @
  @       @
  @ @ @
```

The problem is that algorithm don't see that `L` figure can be applied here.
Thats because it trying to apply `L` like that:
```
  @ @ @ @ @ @
  @ @ @ @   @
  @ @ !     @
  X X X @
```
Lets [fix](https://github.com/stokarenko/it-duel-2016/blob/master/lib/tetris/diagonal_position_strategy.rb#L9) this problem.

## The solution
Clone it.
Bundle it.

Run it:
```console
  $ ./tetris net_solve {SIZE} [TIMEOUT]
```

Output sample, for 50 size:
```console
  [23.53s] {"id"=>407833, "size"=>50, "signature"=>"I49,J127,L49,O13,S127,T126,Z134"}
  [0.07s] Solved!
  [0.32s] {"puzzle_id"=>407833, "solved"=>true, "submitted_at"=>"2015-12-06T16:48:07.162Z"}
  ==========================================

  [78.88s] {"id"=>407835, "size"=>50, "signature"=>"I50,J114,L65,O17,S155,T94,Z130"}
  [0.06s] Solved!
  [0.16s] {"puzzle_id"=>407835, "solved"=>true, "submitted_at"=>"2015-12-06T16:49:26.296Z"}
  ==========================================

  [18.79s] {"id"=>407836, "size"=>50, "signature"=>"I41,J101,L61,O16,S154,T136,Z116"}
  [0.06s] Solved!
  [0.25s] {"puzzle_id"=>407836, "solved"=>true, "submitted_at"=>"2015-12-06T16:49:45.374Z"}
  ==========================================

  [69.96s] {"id"=>407837, "size"=>50, "signature"=>"I52,J106,L47,O12,S156,T110,Z142"}
  [0.06s] Solved!
  [7.68s] {"puzzle_id"=>407837, "solved"=>true, "submitted_at"=>"2015-12-06T16:51:03.098Z"}
```

Want to see how it works internally? There is a verbose mode of solving.
Choose the test case in `lib/tetris/test.rb`, run something like:
```console
  $ ./tetris test 12 -v
```

## TODO
* Fix message on timeout, the problem is not solved in this case ))
* Move API URL and token to config file
* Recursion to iterative (?)

## LICENSE
MIT License. Copyright (c) 2015 Sergey Tokarenko, Dmitriy Kiriyenko, Alexey Kudryashov.
