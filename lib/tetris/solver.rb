# Copyright (c) 2015 Sergey Tokarenko

require 'timeout'

module Tetris
  class Solver
    STRATEGY = DiagonalCellStrategy

    attr_reader :size, :blocks, :block_masks

    def initialize(options)
      @size = options.fetch(:size) + 2
      @blocks = parse_blocks(options.fetch(:signature))

      @block_masks = BlockMasks[size]
    end

    def solve(options = {})
      #Damn, Thor provides symbol options keys, but they not available by .fetch (
      timeout = (options[:timeout] || 0).to_i
      verbose = options[:verbose] || false

      available_blocks = BalancedBlocksContainer.new(blocks)

      catch(:done){
        Timeout.timeout(timeout) {
          _solve(BoardWithBorder[size], size+1, available_blocks, [], verbose)
        }
      }.map!{ |block_id, angle_id, mask_cell|
        [block_id, angle_id, mask_cell % size - 1, mask_cell / size - 1]
      }
    rescue Timeout::Error
      nil
    end

    private

    def _solve(board, cell, available_blocks, solution, verbose)
      print_board(board) if verbose

      throw(:done, solution) unless cell

      available_blocks.each do |block_id, number|
        unless number == 0
          (0...block_masks[block_id].size).each do |angle_id|
            new_board, new_cell, mask_cell = apply_block(board, cell, block_id, angle_id)
            if new_board
              available_blocks.take(block_id)
              solution << [block_id, angle_id, mask_cell]

              _solve(new_board, new_cell, available_blocks, solution, verbose)

              available_blocks.return(block_id)
              solution.pop
            end
          end
        end
      end
    end

    def apply_block(board, cell, block_id, angle_id)
      mask = block_masks[block_id][angle_id]

      STRATEGY.each_mask_cell(size, cell, block_id, angle_id, mask[:first_filled_cell]) do |mask_cell|
        celled_mask = mask[:mask] << mask_cell

        if board & celled_mask == 0
          new_board = board + celled_mask
          new_cell = next_cell(new_board, cell)

          if new_cell.nil? || (
            Connectivity.check(size, new_board, new_cell) &&
            STRATEGY.check_pathologies(new_board, size, block_id, angle_id, mask_cell)
          )
            return [new_board, new_cell, mask_cell]
          end
        end
      end

      false
    end

    def next_cell(board, cell)
      cell = STRATEGY.next(size, cell) while(board[cell] == 1)

      cell / size < size ? cell : nil
    end

    def parse_blocks(signature)
      Hash[
        signature.
          scan(/(\w)(\d+)/).
          map{ |block_id, number| [block_id.to_sym, number.to_i] }.
          select{ |_, number| number > 0 }
      ]
    end

    def print_board(board)
      (0...size**2).each do |i|
        print (board[i] == 0 ? '_' : '@')
        puts if (i+1) % size == 0
      end

      print "\r" + ("\e[A" * size)
    end

  end
end