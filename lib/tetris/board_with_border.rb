# Copyright (c) 2015 Sergey Tokarenko

module Tetris
  module BoardWithBorder
    @@boards_cache = {}

    class << self
      def [](size)
        @@boards_cache[size] ||= begin
          top_bottom = (0...size).inject(0){ |mem, i|
            mem + (1 << i) + (1 << size*(size-1)+i)
          }

          (1...size-1).inject(top_bottom){ |mem, i|
            mem + (1 << size*i) + (1 << size*(i+1)-1)
          }
        end
      end
    end
  end
end
