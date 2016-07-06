class Item < ApplicationRecord

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
end
