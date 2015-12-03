# IT duel 2016 at Anadea inc.

Epic win! :)

The challenge format - single creative problem, seven 4-max teams, 5 hours for solving,

The winner team: Sergey Tokarenko, Dmitriy Kiriyenko, Alexey Kudryashov.

![](epic_win.jpg)

## The problem
Look at the [task definition](http://tetro.andy128k.net/).

## The solution
Clone it.
Bundle it.

Run it:
```console
  $ ./tetris net_solve {SIZE} [TIMEOUT]
```

Output sample, for 48 size:
```console
  [53.18s] {"id"=>407680, "size"=>48, "signature"=>"I38,J122,L48,O11,S130,T114,Z113"}
  [0.65s] Solved!
  [0.17s] {"puzzle_id"=>407680, "solved"=>true, "submitted_at"=>"2015-12-03T04:17:14.866Z"}
  ==========================================

  [34.41s] {"id"=>407681, "size"=>48, "signature"=>"I44,J116,L52,O13,S119,T104,Z128"}
  [0.57s] Solved!
  [0.57s] {"puzzle_id"=>407681, "solved"=>true, "submitted_at"=>"2015-12-03T04:17:50.420Z"}
  ==========================================

  [27.85s] {"id"=>407682, "size"=>48, "signature"=>"I41,J121,L41,O12,S123,T126,Z112"}
  [0.59s] Solved!
  [0.30s] {"puzzle_id"=>407682, "solved"=>true, "submitted_at"=>"2015-12-03T04:18:19.117Z"}
  ==========================================

  [4.13s] {"id"=>407683, "size"=>48, "signature"=>"I49,J108,L36,O10,S138,T104,Z131"}
  [0.73s] Solved!
  [0.28s] {"puzzle_id"=>407683, "solved"=>true, "submitted_at"=>"2015-12-03T04:18:24.257Z"}
  ==========================================
```

Want to see how it work? Choose the test case in `lib/tetris/test.rb`, run something like:
```console
  $ ./tetris test 12 -v
```

## TODO
* Fix message on timeout, the problem is not solved in this case ))
* Fix verbose output
* Discover the remaining pathological cases

MIT License. Copyright (c) 2015 Sergey Tokarenko, Dmitriy Kiriyenko, Alexey Kudryashov.
