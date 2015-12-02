# Copyright (c) 2015 Sergey Tokarenko

require 'benchmark'

module Tetris
  module Test
    CASES = [
      {size: 4, signature: 'I1,J1,L1,Z1'}, #0
      {size: 10, signature: 'I4,J4,L4,O1,S1,T4,Z7'}, #1
      {size: 12, signature: 'I3,J5,L4,O1,S6,T8,Z9'}, #2
      {size: 14, signature: 'I2,J11,L9,O1,S9,T6,Z11'}, #3
      {size: 16, signature: 'I6,J18,L5,O2,S9,T12,Z12'}, #4
      {size: 18, signature: 'I14,J15,L7,O1,S14,T16,Z14'}, #5
      {size: 20, signature: 'I7,J21,L18,O3,S14,T20,Z17'}, #6
      {size: 30, signature: 'I18,J41,L30,O1,S34,T54,Z47'}, #7
      {size: 30, signature: 'I33,J42,L13,O5,S46,T40,Z46'}, #8
      {size: 48, signature: 'I42,J107,L38,O25,S127,T102,Z135'}, #9
      {size: 48, signature: 'I43,J96,L64,O12,S145,T96,Z120'}, #10 PATOLOGIC
      {size: 50, signature: 'I60,J103,L46,O21,S137,T126,Z132'} #11
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