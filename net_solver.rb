# Copyright (c) 2015 Dmitriy Kiriyenko

require 'httparty'
require_relative 'tetris'

SIZE = ARGV[0].to_i
TIMEOUT = ARGV[1].to_i
TOKEN = "0c07cedd-397b-491a-9173-370a1969dd97"

class Tetramino
  include HTTParty
  base_uri "http://tetro.andy128k.net/api/"
  format :json

  def make_query(params)
    params.merge(token: TOKEN)
  end

  def fetch
    self.class.get("/puzzle", query: make_query(size: SIZE)).parsed_response.tap {|x| puts x}
  end

  def solve(task)
    Tetris.new(id: task["id"], size: SIZE, signature: task["signature"]).solve(timeout: TIMEOUT)
  end

  def send(task, result)
    self.class.post("/puzzle", body: make_query(id: task["id"], solution: result.to_json)).parsed_response.tap {|x| puts x}
  end

  def work!
    task = fetch
    res = solve(task)
    send(task, res) if res
  end

end

client = Tetramino.new

while true
  puts "=" * 42
  puts
  client.work!
end
