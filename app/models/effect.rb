require 'digest/md5'

class Effect < ApplicationRecord
	def self.create_from_url(url = nil)
		return unless url
		
		result = ::Game.get(url)
		puts "creating #{result.length} effect(s)"
		JSON.parse(result.body).each do |r|

			the_long_string = r.to_s
			fingerprint = Digest::MD5.hexdigest(the_long_string)

			if Effect.find_by_fingerprint(fingerprint)
				puts "skipping #{fingerprint}"
				next
			end

			Effect.create(occurred_at: r['Timestamp'],
				fingerprint: fingerprint,
				creator: r['Creator'],
				target: r['Targets'],
				name: r['Effect']['EffectName'],
				effect_type: r['Effect']['EffectType'],
				vote_gain: r['Effect']['VoteGain'],
				description: r['Effect']['Description'],
				details: the_long_string)
		end
	end

end
