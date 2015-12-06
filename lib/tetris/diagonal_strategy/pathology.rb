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

=begin
TODO
  @@@@@@@@@@@@@@@@@@@@@@@____________________________@
  @@@@@@@@@@@@@@@@@@_@@______________________________@
  @@@@@@@@@@@@@@@@@__@@______________________________@
  @@@@@@@@@@@@@@@@___________________________________@
  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
=end

        def check(board, size, figure_id, angle_id, mask_cell)
          if angle_id == 1 && (figure_id == :J || figure_id == :I)
            cell = figure_id == :J ? mask_cell : mask_cell - size + 1

            if board[cell+1] == 0 && board[cell+2] == 0 && board[cell+3] == 0 &&
               board[cell-size+2] == 1 && board[cell-size+3] == 0 && board[cell-size+4] == 1 &&
               board[cell-2*size+3] == 0 && board[cell-2*size+4] == 1
              return false
            end
          end

          true
        end

      end
    end
  end
end
