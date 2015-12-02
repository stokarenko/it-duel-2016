# Copyright (c) 2015 Sergey Tokarenko

require 'benchmark'

module Tetris
  module Test
    CASES = [
      {size: 4, signature: 'I1,J1,L1,Z1'},
      {size: 10, signature: 'I4,J4,L4,O1,S1,T4,Z7'},
      {size: 12, signature: 'I3,J5,L4,O1,S6,T8,Z9'},
      {size: 14, signature: 'I2,J11,L9,O1,S9,T6,Z11'},
      {size: 16, signature: 'I6,J18,L5,O2,S9,T12,Z12'},
      {size: 18, signature: 'I14,J15,L7,O1,S14,T16,Z14'},
      {size: 20, signature: 'I7,J21,L18,O3,S14,T20,Z17'},
      {size: 30, signature: 'I18,J41,L30,O1,S34,T54,Z47'},
      {size: 50, signature: 'I60,J103,L46,O21,S137,T126,Z132'}
    ].freeze

    class << self
      def run(case_id, options)
        res = nil

        benchmark = Benchmark.measure {
          res = Solver.new(CASES[case_id]).solve(options)
        }

        p res
        puts benchmark
      end
    end
  end
end