# Copyright (c) 2015 Sergey Tokarenko

module Tetris
  module Connectivity
    class << self
      def check(size, board, cell)
        empty_points = Array.new(size**2, false)
        empty_points[cell] = true

        empty_cells_count = 1
        queue = [cell]

        while(center_cell = queue.shift)
          nearby_cells(size, center_cell) do |nearby_cell|
            if !empty_points[nearby_cell] && board[nearby_cell] == 0
              empty_points[nearby_cell] = true
              queue.push(nearby_cell)
              empty_cells_count += 1
            end
          end
        end

        empty_cells_count % 4 == 0
      end

      private

      def nearby_cells(size, center_cell)
        # return enum_for(:nearby_cells, size, center_cell) unless block_given?
        yield(center_cell - 1)
        yield(center_cell + 1)
        yield(center_cell - size)
        yield(center_cell + size)
      end

    end
  end
end
