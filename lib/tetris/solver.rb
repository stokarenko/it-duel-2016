# Copyright (c) 2015 Sergey Tokarenko

require 'timeout'

module Tetris
  class Solver
    STRATEGY = DiagonalPositionStrategy

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
          _solve(FieldWithBorder[size], size+1, available_blocks, [], verbose)
        }
      }.map!{ |block_id, angle_id, mask_position|
        [block_id, angle_id, mask_position % size - 1, mask_position / size - 1]
      }
    rescue Timeout::Error
      nil
    end

    private

    def _solve(field, position, available_blocks, solution, verbose)
      print_field(field) if verbose

      throw(:done, solution) unless position

      available_blocks.each do |block_id, number|
        unless number == 0
          (0...block_masks[block_id].size).each do |angle_id|
            new_field, new_position, mask_position = apply_block(field, position, block_id, angle_id)
            if new_field
              available_blocks.take(block_id)
              solution << [block_id, angle_id, mask_position]

              _solve(new_field, new_position, available_blocks, solution, verbose)

              available_blocks.return(block_id)
              solution.pop
            end
          end
        end
      end
    end

    def apply_block(field, position, block_id, angle_id)
      mask = block_masks[block_id][angle_id]

      STRATEGY.each_mask_position(size, position, block_id, angle_id, mask[:first_point_position]) do |mask_position|
        positioned_mask = mask[:mask] << mask_position

        if field & positioned_mask == 0
          new_field = field + positioned_mask
          new_position = next_position(new_field, position)

          if new_position.nil? || (
            Connectivity.check(size, new_field, new_position) &&
            STRATEGY.check_pathologies(new_field, size, block_id, angle_id, mask_position)
          )
            return [new_field, new_position, mask_position]
          end
        end
      end

      false
    end

    def next_position(field, position)
      position = STRATEGY.next(size, position) while(field[position] == 1)

      position / size < size ? position : nil
    end

    def parse_blocks(signature)
      Hash[
        signature.
          scan(/(\w)(\d+)/).
          map{ |block_id, number| [block_id.to_sym, number.to_i] }.
          select{ |_, number| number > 0 }
      ]
    end

    def print_field(field)
      (0...size**2).each do |i|
        print (field[i] == 0 ? '_' : '@')
        puts if (i+1) % size == 0
      end

      print "\r" + ("\e[A" * size)
    end

  end
end