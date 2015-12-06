# Copyright (c) 2015 Sergey Tokarenko

module Tetris
  class BalancedFiguresContainer

    attr_reader :ordered_figures

    def initialize(figures)
      @ordered_figures = figures.to_a
      sort!
    end

    def each
      ordered_figures.each do |figure_id, number|
        yield(figure_id) if number > 0
      end
    end

    def change(figure_id, diff)
      index = ordered_figures.index{|ordered_figure_id, _| ordered_figure_id == figure_id}
      ordered_figures[index][1] += diff

      sort!
    end

    private

    def sort!
      ordered_figures.sort!{ |(figure_id1, number1), (figure_id2, number2)|
        number2 == number1 ?
          figure_id2 <=> figure_id1 :
          number2 <=> number1
      }
    end

  end
end
