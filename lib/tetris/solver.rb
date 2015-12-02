# Copyright (c) 2015 Sergey Tokarenko

require 'timeout'

module Tetris
  class Solver
    DEFAULT_BLOCKS_ORDER = %i(I S Z J L T O).freeze

    attr_reader :size, :blocks, :blocks_count, :block_masks

    def initialize(options)
      @size = options.fetch(:size) + 2
      @blocks = parse_blocks(options.fetch(:signature))
      @blocks_count = @blocks.values.reduce(:+)

      @block_masks = BlockMasks[size]
    end

    def solve(options = {})
      #Damn, Thor provides symbol options keys, but they not available by .fetch (
      timeout = (options[:timeout] || 0).to_i
      verbose = options[:verbose] || false

      available_blocks = sort_blocks(options.fetch(:blocks_order, DEFAULT_BLOCKS_ORDER))

      catch(:done){
        Timeout.timeout(timeout) do
          _solve(FieldWithBorder[size], size+1, available_blocks, [], verbose)
        end
      }.map!{ |block_id, angle_id, mask_position|
        [block_id, angle_id, mask_position % size - 1, mask_position / size - 1]
      }
    rescue Timeout::Error
      nil
    end

    private

    def _solve(field, position, available_blocks, solution, verbose)
      print_field(field) if verbose

      throw(:done, solution) if solution.size == blocks_count

      available_blocks.each do |block_id, number|
        unless number == 0
          block_masks[block_id].each_with_index do |mask, angle_id|
            new_field, new_position, mask_position = apply_block(field, position, mask)
            if new_field
              available_blocks[block_id] -= 1
              solution << [block_id, angle_id, mask_position]

              _solve(new_field, new_position, available_blocks, solution, verbose)

              available_blocks[block_id] += 1
              solution.pop
            end
          end
        end
      end
    end

    def apply_block(field, position, mask)
      mask_position = position - mask[:first_point_position]
      positioned_mask = mask[:mask] << mask_position

      if field & positioned_mask == 0
        new_field = field + positioned_mask
        [new_field, next_position(new_field, position), mask_position]
      else
        false
      end
    end

    def next_position(field, position)
      position += 1 while(field[position] == 1)

      position
    end

    def parse_blocks(signature)
      Hash[
        signature.
          scan(/(\w)(\d+)/).
          map{ |block_id, number| [block_id.to_sym, number.to_i] }.
          select{ |_, number| number > 0 }
      ]
    end

    def sort_blocks(blocks_order)
      Hash[
        blocks_order.map{ |z|
          blocks.key?(z) ? [z, blocks[z]] : nil
        }.compact
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