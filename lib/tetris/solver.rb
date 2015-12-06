# Copyright (c) 2015 Sergey Tokarenko

require 'timeout'

module Tetris
  class Solver
    STRATEGY = DiagonalStrategy

    attr_reader :size, :figures

    def initialize(options)
      @size = options.fetch(:size) + 2
      @figures = parse_signature(options.fetch(:signature))
    end

    def solve(options = {})
      #Damn, Thor provides symbol options keys, but they not available by .fetch (
      timeout = (options[:timeout] || 0).to_i
      verbose = options[:verbose] || false

      available_figures = BalancedFiguresContainer.new(figures)
      board = BoardWithBorder[size]

      BoardPrinter.print(size, board) if verbose

      catch(:done){
        Timeout.timeout(timeout) {
          _solve(board, size+1, available_figures, [], verbose)
        }
      }.map!{ |figure_id, angle_id, mask_cell|
        [figure_id, angle_id, mask_cell % size - 1, mask_cell / size - 1]
      }
    rescue Timeout::Error
      nil
    end

    private

    def _solve(board, cell, available_figures, solution, verbose)
      BoardPrinter.update(size, board) if verbose

      throw(:done, solution) unless cell

#TODO fix enum, fix order
      available_figures.each do |figure_id, number|
        unless number == 0
          FigureMasks[size][figure_id].size.times do |angle_id|
            new_board, new_cell, mask_cell = apply_figure(board, cell, figure_id, angle_id)
            if new_board
              available_figures.take(figure_id)
              solution << [figure_id, angle_id, mask_cell]

              _solve(new_board, new_cell, available_figures, solution, verbose)

              available_figures.return(figure_id)
              solution.pop
            end
          end
        end
      end
    end

    def apply_figure(board, cell, figure_id, angle_id)
      mask = FigureMasks[size][figure_id][angle_id]

      STRATEGY::Pathology.mask_cells(size, cell, figure_id, angle_id, mask[:first_filled_cell]) do |mask_cell|
        celled_mask = mask[:mask] << mask_cell

        if board & celled_mask == 0
          new_board = board + celled_mask
          new_cell = STRATEGY::Cell.next(new_board, size, cell)

          if new_cell.nil? || (
            STRATEGY::Connectivity.check(size, new_board, new_cell) &&
            STRATEGY::Pathology.check(new_board, size, figure_id, angle_id, mask_cell)
          )
            return [new_board, new_cell, mask_cell]
          end
        end
      end

      false
    end

    def parse_signature(signature)
      Hash[
        signature.
          scan(/(\w)(\d+)/).
          map{ |figure_id, number| [figure_id.to_sym, number.to_i] }.
          select{ |_, number| number > 0 }
      ]
    end

  end
end
