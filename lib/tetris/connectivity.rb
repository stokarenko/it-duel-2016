# Copyright (c) 2015 Sergey Tokarenko

module Tetris
  module Connectivity
    class << self
      def check(size, field, position)
        empty_points = Array.new(size**2, false)
        empty_points[position] = true

        queue = [position]
        while(center_position = queue.shift)
          [center_position-1, center_position+1, center_position-size, center_position+size].each do |nearby_position|
            if !empty_points[nearby_position] && field[nearby_position] == 0
              empty_points[nearby_position] = true
              queue.push(nearby_position)
            end
          end
        end

        empty_points.count{|i| i} % 4 == 0
      end
    end
  end
end