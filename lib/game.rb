require 'httparty'

class Game
  include HTTParty
  base_uri 'http://thegame.nerderylabs.com:1337/'
  # logger  ::Logger.new('logfile.log'), :info
  default_timeout 10

  headers 'apikey' => ENV['APIKEY']
end