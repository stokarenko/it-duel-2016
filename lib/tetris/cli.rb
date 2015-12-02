# Copyright (c) 2015 Sergey Tokarenko

require 'thor'

module Tetris
  class CLI < Thor
    include Thor::Actions

    desc 'net_solve SIZE [TIMEOUT]', 'Rush net solving!!'
    def net_solve(size, timeout = 0)
      NetSolver.new(size.to_i, timeout.to_i).work!
    end

    desc 'test CASE [OPTIONS]', 'Test specific case'
    method_option 'verbose', type: :boolean, default: false,
      aliases: '-v',
      banner: 'Look how it works =).'
    def test(case_id)
      Test.run(case_id.to_i, options)
    end

  end
end