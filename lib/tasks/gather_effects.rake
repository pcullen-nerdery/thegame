require 'json'
require 'httparty'

task gather_effects: :environment do
	while true do
		Effect.create_from_url("/effects")
		puts "effects retrival complete"
	end
end
