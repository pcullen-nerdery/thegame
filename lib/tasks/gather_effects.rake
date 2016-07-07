require 'json'
require 'httparty'

task gather_effects: :environment do
  # puts "Starting thread for gathering effects"
  while true do
    Effect.create_from_url('/effects')
    sleep 30
  end
end
