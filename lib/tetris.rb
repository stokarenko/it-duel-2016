# Copyright (c) 2015 Sergey Tokarenko

module Tetris
  autoload :CLI, 'tetris/cli'

  autoload :NetSolver, 'tetris/net_solver'
  autoload :Solver,    'tetris/solver'

  autoload :MaskUtils,                'tetris/mask_utils'
  autoload :FigureMasks,              'tetris/figure_masks'
  autoload :BoardWithBorder,          'tetris/board_with_border'
  autoload :BoardPrinter,             'tetris/board_printer'
  autoload :BalancedFiguresContainer, 'tetris/balanced_figures_container'

  autoload :DiagonalStrategy, 'tetris/diagonal_strategy'

  autoload :Test, 'tetris/test'
end
