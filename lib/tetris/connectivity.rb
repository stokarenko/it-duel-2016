# Copyright (c) 2015 Sergey Tokarenko

module Tetris
  module Connectivity
    class << self
      def check(size, board, cell)
        empty_points = Array.new(size**2, false)
        empty_points[cell] = true

        queue = [cell]
        while(center_cell = queue.shift)
          [center_cell-1, center_cell+1, center_cell-size, center_cell+size].each do |nearby_cell|
            if !empty_points[nearby_cell] && board[nearby_cell] == 0
              empty_points[nearby_cell] = true
              queue.push(nearby_cell)
            end
          end
        end

        empty_points.count{|i| i} % 4 == 0
      end
    end
  end
end
