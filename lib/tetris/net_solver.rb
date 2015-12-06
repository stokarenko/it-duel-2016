# Copyright (c) 2015 Dmitriy Kiriyenko, Alexey Kudryashov, Sergey Tokarenko.

require 'httparty'
require 'benchmark'

module Tetris
  class NetSolver
    #TODO move to config
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
        work rescue Net::ReadTimeout
      end
    end

    private

    def make_query(params)
      params.merge(token: TOKEN)
    end

    def fetch
      benchmark do
        self.class.get("/puzzle", query: make_query(size: size)).parsed_response
      end
    end

    def solve(task)
      benchmark('Solved!') do
        Solver.new(size: size, signature: task["signature"]).solve(timeout: timeout)
      end
    end

    def send(task, result)
      benchmark do
        self.class.post("/puzzle", body: make_query(id: task["id"], solution: result.to_json)).parsed_response
      end
    end

    def benchmark(message = nil)
      res = nil

      benchmark = Benchmark.measure {
        res = yield
      }
      puts "[%.2fs] %s" % [benchmark.real, message || res]

      res
    end

  end
end
