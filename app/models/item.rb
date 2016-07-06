class Item < ApplicationRecord

	def use(target = nil)
		if target
			Rails.logger.info ::Game.post("/items/use/#{guid}?target=#{target}")
		else
			Rails.logger.info ::Game.post("/items/use/#{guid}")
		end

		self.update(status: 'Used')
	end
end
