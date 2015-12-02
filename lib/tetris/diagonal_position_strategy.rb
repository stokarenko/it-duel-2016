# Copyright (c) 2015 Sergey Tokarenko

module Tetris
  module DiagonalPositionStrategy
    class << self
      def next(size, position)
        if position / size == size - 2
          (position % size + 2) * size - 2
        elsif position % size == 1
          position / size + size + 1
        else
          position + size - 1
        end
      end
    end
  end
end
