# Copyright (c) 2015 Sergey Tokarenko

module Tetris
  class BalancedBlocksContainer

    attr_reader :ordered_blocks

    def initialize(blocks)
      @ordered_blocks = blocks.each_pair.sort{ |(_, number1), (_, number2)|
        number2 <=> number1
      }
    end

    def each(&block)
      ordered_blocks.each(&block)
    end

    def take(block_id)
      index = index_by_block_id(block_id)
      ordered_blocks[index][1] -= 1

      while(index < ordered_blocks.size-1 && ordered_blocks[index][1] < ordered_blocks[index+1][1])
        ordered_blocks[index], ordered_blocks[index+1] = ordered_blocks[index+1], ordered_blocks[index]
        index += 1
      end
    end

    def return(block_id)
      index = index_by_block_id(block_id)
      ordered_blocks[index][1] += 1

      while(index > 0 && ordered_blocks[index][1] > ordered_blocks[index-1][1])
        ordered_blocks[index], ordered_blocks[index-1] = ordered_blocks[index-1], ordered_blocks[index]
        index -= 1
      end
    end

    private

    def index_by_block_id(block_id)
      ordered_blocks.index{|ordered_block_id, _| ordered_block_id == block_id}
    end

  end
end