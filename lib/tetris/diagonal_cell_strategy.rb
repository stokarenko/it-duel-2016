# Copyright (c) 2015 Sergey Tokarenko

module Tetris
  module DiagonalCellStrategy
    class << self
      def each_mask_cell(size, cell, block_id, angle_id, first_filled_cell)
        yield(cell - first_filled_cell)

        if block_id == :L && angle_id == 3
          yield(cell - size)
        end
      end

      def next(size, cell)
        if cell / size == size - 2
          (cell % size + 2) * size - 2
        elsif cell % size == 1
          cell / size + size + 1
        else
          cell + size - 1
        end
      end

      def check_pathologies(board, size, block_id, angle_id, mask_cell)
        if angle_id == 1 && (block_id == :J || block_id == :I)
          cell = block_id == :J ? mask_cell : mask_cell - size + 1

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
