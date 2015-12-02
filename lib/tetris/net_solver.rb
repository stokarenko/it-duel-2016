# Copyright (c) 2015 Dmitriy Kiriyenko, Alexey Kudryashov, Sergey Tokarenko.

require 'httparty'

module Tetris
  class NetSolver
    TOKEN = '0c07cedd-397b-491a-9173-370a1969dd97'
    API_URL = 'http://tetro.andy128k.net/api/'

    include HTTParty
    base_uri API_URL
    format :json

    attr_reader :size, :timeout

    def initialize(size, timeout)
      @size, @timeout = size, timeout
    end

    def work
      task = fetch
      res = solve(task)
      send(task, res) if res
    end

    def work!
      while true
        puts "=" * 42
        puts
        work
      end
    end

    private

    def make_query(params)
      params.merge(token: TOKEN)
    end

    def fetch
      self.class.get("/puzzle", query: make_query(size: size)).parsed_response.tap {|x| puts x}
    end

    def solve(task)
      Solver.new(size: size, signature: task["signature"]).solve(timeout: timeout)
    end

    def send(task, result)
      self.class.post("/puzzle", body: make_query(id: task["id"], solution: result.to_json)).parsed_response.tap {|x| puts x}
    end

  end
end