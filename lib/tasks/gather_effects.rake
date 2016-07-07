require 'json'
require 'httparty'

task gather_effects: :environment do
	while true do
		begin
			Effect.create_from_url("/effects")
			puts "effects retrival complete"
		rescue Net::ReadTimeout, Errno::ETIMEDOUT, Net::OpenTimeout, JSON::ParserError => e
			puts "rescued `#{e.class.name}`, retrying"
			sleep 2
			retry
		end
	end
end
