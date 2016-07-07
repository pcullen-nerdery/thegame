class Item < ApplicationRecord
	scope :current_game, -> { where("status != 'Previous Game' or status is null") }
	scope :unused, -> { where("status != 'Used' or status is null") }

	def use!(target = nil)
		if target
			result = ::Game.post("/items/use/#{guid}?target=#{target}")
		else
			result = ::Game.post("/items/use/#{guid}")
		end
		self.update(status: 'Used')

		File.open("#{Rails.root}/tmp/last_used_time", 'w') do |f|
			f.write Time.now
		end

		Rails.logger.info result
		result
	end


	def self.use_items(items = [])
		items.each do |item|
			result = Item.find_by_guid(item).use!
			sleep 70
		end
	end
end
