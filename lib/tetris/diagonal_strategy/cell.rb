# Copyright (c) 2015 Sergey Tokarenko

module Tetris
  module DiagonalStrategy
    module Cell
      class << self

        def next(board, size, cell)
          cell = _next(size, cell) while(cell && board[cell] == 1)

          cell
        end

        private

        def _next(size, cell)
          if cell / size == size - 2
            cell % size == size - 2 ?
              nil :
              (cell % size + 2) * size - 2
          elsif cell % size == 1
            cell / size + size + 1
          else
            cell + size - 1
          end
        end

      end
    end
  end
end
