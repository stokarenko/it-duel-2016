# Copyright (c) 2015 Sergey Tokarenko

module Tetris
  module FigureMasks
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

    @@figure_masks_cache = {}

    class << self

      def [](size)
        @@figure_masks_cache[size] ||= begin
          pairs = figure_patterns.map{ |figure_id, patterns|
            masks = patterns.map{ |pattern|
              pattern.dup.tap{ |mask|
                line_patterns = mask.delete(:line_patterns)
                mask[:mask] = MaskUtils.compile_line_patterns(line_patterns, size)
              }
            }

            [figure_id, masks]
          }

          Hash[pairs].freeze
        end
      end

      private

      def figure_patterns
        @@figure_patterns ||= begin
          pairs = BLOCKS.map{ |figure_id, main_figure|
            rotated_figures = [main_figure]
            (1..3).each do |i|
              rotated_figures[i] = rotated_figures[i-1].reverse.transpose
            end
            rotated_figures.uniq!

            figure_rotation_patterns = rotated_figures.map{ |figure|
              {
                first_filled_cell: figure.first.index(1),
                line_patterns: MaskUtils.line_patterns(figure)
              }
            }

            [figure_id, figure_rotation_patterns]
          }

          Hash[pairs]
        end
      end
    end
  end
end
