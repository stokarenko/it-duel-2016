# Copyright (c) 2015 Sergey Tokarenko

module Tetris
  class BalancedFiguresContainer

    attr_reader :ordered_figures

    def initialize(figures)
      @ordered_figures = figures.each_pair.sort{ |(_, number1), (_, number2)|
        number2 <=> number1
      }
    end

    def each(&figure)
      ordered_figures.each(&figure)
    end

    def take(figure_id)
      index = index_by_figure_id(figure_id)
      ordered_figures[index][1] -= 1

      while(index < ordered_figures.size-1 && ordered_figures[index][1] < ordered_figures[index+1][1])
        ordered_figures[index], ordered_figures[index+1] = ordered_figures[index+1], ordered_figures[index]
        index += 1
      end
    end

    def return(figure_id)
      index = index_by_figure_id(figure_id)
      ordered_figures[index][1] += 1

      while(index > 0 && ordered_figures[index][1] > ordered_figures[index-1][1])
        ordered_figures[index], ordered_figures[index-1] = ordered_figures[index-1], ordered_figures[index]
        index -= 1
      end
    end

    private

    def index_by_figure_id(figure_id)
      ordered_figures.index{|ordered_figure_id, _| ordered_figure_id == figure_id}
    end

  end
end