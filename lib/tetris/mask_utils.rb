# Copyright (c) 2015 Sergey Tokarenko

module Tetris
  module MaskUtils
    class << self
      def line_patterns(block)
        block.reverse.map{ |line|
          line.reverse.reduce(0){|mem, new_bit|
            (mem << 1) + new_bit
          }
        }
      end

      def compile_line_patterns(line_patterns, size)
        line_patterns.reduce(0) { |mem, line_pattern|
          (mem << size) + line_pattern
        }
      end
    end
  end
end