# Copyright (c) 2015 Sergey Tokarenko

module Tetris
  module BoardPrinter
    class << self

      def print(size, board)
        puts output_str(size, board)
      end

      def update(size, board)
        puts "\r" + ("\e[A" * size) + output_str(size, board)
      end

      private

      def output_str(size, board)
        (0...size**2).reduce(''){ |mem, cell|
          mem + (board[cell] == 0 ? '_' : '@') + ((cell+1) % size == 0 ? "\n" : '')
        }
      end
    end
  end
end
