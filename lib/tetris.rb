# Copyright (c) 2015 Sergey Tokarenko

module Tetris
  autoload :CLI, 'tetris/cli'

  autoload :NetSolver,        'tetris/net_solver'
  autoload :Solver,           'tetris/solver'

  autoload :MaskUtils,                      'tetris/mask_utils'
  autoload :BlockMasks,                     'tetris/block_masks'
  autoload :FieldWithBorder,                'tetris/field_with_border'
  autoload :BalancedBlocksContainer,        'tetris/balanced_blocks_container'
  autoload :Connectivity,                   'tetris/connectivity'

  autoload :DiagonalPositionStrategy,       'tetris/diagonal_position_strategy'

  autoload :Test,             'tetris/test'
end