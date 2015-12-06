# Copyright (c) 2015 Sergey Tokarenko

module Tetris
  module DiagonalStrategy
    module Pathology
      class << self

        def mask_cells(size, cell, figure_id, angle_id, first_filled_cell)
          yield(cell - first_filled_cell)

          if figure_id == :L && angle_id == 3
            yield(cell - size)
          end
        end

        def check(board, size, figure_id, angle_id, mask_cell)
          # @@@@@@@@@@@@@@@@@@@@@@@@@@@________________________@
          # @@@@@@@@@@@@@@@@@@@@@@@@@@@________________________@
          # @@@@@@@@@@@@@@@@@@@@@@@@@_@________________________@
          # @@@@@@@@@@@@@@@@@@@@@@@@?_@________________________@
          # @@@@@@@@@@@@@@@@@@@@@@@____________________________@
          # @@@@@@@@@@@@@@@@@@@@@@@@@__________________________@

          cell = if figure_id == :J && angle_id == 1
            mask_cell
          elsif figure_id == :I && angle_id == 1
            mask_cell - size + 1
          elsif figure_id == :L && angle_id == 2 && mask_cell / size == size - 5
            mask_cell + 3*size - 3
          elsif figure_id == :I && angle_id == 0 && mask_cell / size == size - 6
            mask_cell + 4*size - 4
          end

          !(
            cell &&
            board[cell+1] == 0 && board[cell+2] == 0 && board[cell+3] == 0 &&
            board[cell-size+3] == 0 && board[cell-size+4] == 1 &&
            board[cell-2*size+2] == 1 && board[cell-2*size+3] == 0 && board[cell-2*size+4] == 1
          )
        end
      end
    end
  end
end
