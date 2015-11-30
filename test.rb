require 'benchmark'
require_relative 'tetris'

params =
#  {id: 367131, size: 4, signature: 'I1,J1,L1,Z1'}
#  {id: 367131, size: 10, signature: 'I4,J4,L4,O1,S1,T4,Z7'}
#  {id: 374633, size: 12, signature: 'I3,J5,L4,O1,S6,T8,Z9'}
#  {id: 374633, size: 14, signature: 'I2,J11,L9,O1,S9,T6,Z11'}
#  {id: 374633, size: 16, signature: 'I6,J18,L5,O2,S9,T12,Z12'}
#  {id: 374549, size: 18, signature: 'I14,J15,L7,O1,S14,T16,Z14'}
#  {id: 374633, size: 20, signature: 'I7,J21,L18,O3,S14,T20,Z17'}
#  {id: 374633, size: 50, signature: 'I60,J103,L46,O21,S137,T126,Z132'}
#  {id: 374633, size: 30, signature: 'I18,J41,L30,O1,S34,T54,Z47'}

puts Benchmark.measure {
  p Tetris.new(params).solve
}
