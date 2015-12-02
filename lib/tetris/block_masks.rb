# Copyright (c) 2015 Sergey Tokarenko

module Tetris
  module BlockMasks
    BLOCKS = {
      T:  [
            [1,1,1],
            [0,1,0]
          ],
      I:  [
            [1],
            [1],
            [1],
            [1]
          ],
      O:  [
            [1,1],
            [1,1]
          ],
      L:  [
            [1,0],
            [1,0],
            [1,1]
          ],
      J:  [
            [0,1],
            [0,1],
            [1,1]
          ],
      Z:  [
            [1,1,0],
            [0,1,1]
          ],
      S:  [
            [0,1,1],
            [1,1,0]
          ]
    }.freeze

    @@block_masks_cache = {}

    class << self

      def [](size)
        @@block_masks_cache[size] ||= begin
          pairs = block_patterns.map{ |block_id, patterns|
            masks = patterns.map{ |pattern|
              pattern.dup.tap{ |mask|
                line_patterns = mask.delete(:line_patterns)
                mask[:mask] = line_patterns.reduce(0) { |mem, line_pattern|
                  (mem << size) + line_pattern
                }
              }
            }

            [block_id, masks]
          }

          Hash[pairs].freeze
        end
      end

      private

      def block_patterns
        @@block_patterns ||= begin
          pairs = BLOCKS.map{ |block_id, main_block|
            rotated_blocks = [main_block]
            (1..3).each do |i|
              rotated_blocks[i] = rotated_blocks[i-1].reverse.transpose
            end
            rotated_blocks.uniq!

            block_rotation_patterns = rotated_blocks.map{ |block|
              line_patterns = block.reverse.map{ |line|
                line.reverse.reduce(0){|mem, new_bit|
                  (mem << 1) + new_bit
                }
              }

              {
                first_point_position: block.first.index(1),
                line_patterns: line_patterns
              }
            }

            [block_id, block_rotation_patterns]
          }

          Hash[pairs]
        end
      end
    end
  end
end