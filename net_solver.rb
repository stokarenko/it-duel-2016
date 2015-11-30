# Copyright (c) 2015 Dmitriy Kiriyenko

require 'httparty'
require_relative 'tetris'

SIZE = ARGV[0].to_i
TIMEOUT = ARGV[1].to_i

class Tetramino
  include HTTParty
  base_uri "http://tetro.andy128k.net/api/"
  format :json

  def make_query(params)
    params.merge(token: "0c07cedd-397b-491a-9173-370a1969dd97")
  end

  def fetch
    self.class.get("/puzzle", query: make_query(size: SIZE)).parsed_response
  end

  def solve(task)
    Tetris.new(id: task["id"], size: SIZE, signature: task["signature"]).solve(timeout: TIMEOUT)
  end

  def send(task, result)
    self.class.get("/puzzle", query: make_query(id: task[:id], solution: result.to_json.inspect)).parsed_response
  end

  def work!
    task = fetch
    res = solve(task)
    send(task, res) if res
  end

end

client = Tetramino.new

while true
  p client.work!
end
