class Item < ApplicationRecord
	scope :current_game, -> { where.not(status: 'Previous Game') }
	scope :unused, -> { where.not(status: 'Used') }

	def use!(target = nil)
		if target
			result = ::Game.post("/items/use/#{guid}?target=#{target}")
		else
			result = ::Game.post("/items/use/#{guid}")
		end
		self.update(status: 'Used')

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
