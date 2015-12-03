# Copyright (c) 2015 Sergey Tokarenko

module Tetris
  module DiagonalPositionStrategy
    class << self
      def each_mask_position(size, position, block_id, angle_id, first_point_position)
        yield(position - first_point_position)

        if block_id == :L && angle_id == 3
          yield(position - size)
        end
      end

      def next(size, position)
        if position / size == size - 2
          (position % size + 2) * size - 2
        elsif position % size == 1
          position / size + size + 1
        else
          position + size - 1
        end
      end

      def check_pathologies(field, size, block_id, angle_id, mask_position)
        if angle_id == 1 && (block_id == :J || block_id == :I)
          position = block_id == :J ? mask_position : mask_position - size + 1

          if field[position+1] == 0 && field[position+2] == 0 && field[position+3] == 0 &&
             field[position-size+2] == 1 && field[position-size+3] == 0 && field[position-size+4] == 1 &&
             field[position-2*size+3] == 0 && field[position-2*size+4] == 1
            return false
          end
        end

        true
      end
    end
  end
end
