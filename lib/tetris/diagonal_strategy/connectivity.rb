# Copyright (c) 2015 Sergey Tokarenko

module Tetris
  module DiagonalStrategy
    module Connectivity
      #TODO cleanup..
      DIAGONAL_INDEX_DELTA = 5

      class << self
        def check(size, board, cell)
          min_diagonal_index = diagonal_index(size, cell)
          diagonal_empty_cells = diagonal_empty_cells_count(size, board, cell, min_diagonal_index)

          triangle_edge = min_diagonal_index + DIAGONAL_INDEX_DELTA

          empty_cells = diagonal_empty_cells + if triangle_edge < size - 2
            triangle_area = triangle_edge * (triangle_edge - 1) / 2
            (size - 2)**2 - triangle_area
          else
            triangle_edge = 2 * (size - 2) - triangle_edge

            triangle_edge > 0 ?
              triangle_edge * (triangle_edge + 1) / 2 :
              0
          end

          empty_cells % 4 == 0
        end

        private

        def diagonal_empty_cells_count(size, board, cell, min_diagonal_index)
          empty_cells = Array.new(size**2, false)
          empty_cells[cell] = true

          empty_cells_count = 1
          queue = [cell]

          while(center_cell = queue.shift)
            nearby_cells(size, center_cell, min_diagonal_index) do |nearby_cell|
              if !empty_cells[nearby_cell] && board[nearby_cell] == 0
                empty_cells[nearby_cell] = true
                queue.push(nearby_cell)
                empty_cells_count += 1
              end
            end
          end

          empty_cells_count
        end

        def nearby_cells(size, center_cell, min_diagonal_index)
          center_cell_diagonal_index = diagonal_index(size, center_cell)

          if center_cell_diagonal_index > min_diagonal_index
            yield(center_cell - 1)
            yield(center_cell - size)
          end

          if center_cell_diagonal_index < min_diagonal_index + DIAGONAL_INDEX_DELTA
            yield(center_cell + 1)
            yield(center_cell + size)
          end
        end

        def diagonal_index(size, cell)
          cell % size + cell / size
        end

      end

    end
  end
end
