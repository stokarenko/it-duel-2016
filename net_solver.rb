# Copyright (c) 2015 Dmitriy Kiriyenko

require 'httparty'
require_relative 'tetris'

SIZE = ARGV.first.to_i

class Tetramino
  include HTTParty
  base_uri "http://tetro.andy128k.net/api/"
  format :json

  def make_query(params)
    params.merge(token: "0c07cedd-397b-491a-9173-370a1969dd97")
  end

  def fetch
    res = self.class.get("/puzzle", query: make_query(size: SIZE)).parsed_response
    p res
    res
  end

  def solve(task)
    Tetris.new(id: task["id"], size: SIZE, signature: task["signature"]).solve(timeout: 6)
  end

  def send(task, result)
    command =  "curl --request POST --data \"token=0c07cedd-397b-491a-9173-370a1969dd97&id=#{task["id"]}&solution=#{result.to_json.inspect}\" http://tetro.andy128k.net/api/puzzle"
    puts command
    `#{command}`
  end

  def work!
    task = fetch
    res = solve(task)
    p task: task, solve: res
    send(task, res) if res
  end

end

client = Tetramino.new
# p client.work!

while true
  p client.work!
end
