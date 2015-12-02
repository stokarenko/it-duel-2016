# Copyright (c) 2015 Sergey Tokarenko

module Tetris
  autoload :CLI, 'tetris/cli'

  autoload :NetSolver,        'tetris/net_solver'
  autoload :Solver,           'tetris/solver'

  autoload :BlockMasks,       'tetris/block_masks'
  autoload :FieldWithBorder,  'tetris/field_with_border'

  autoload :Test,             'tetris/test'
end