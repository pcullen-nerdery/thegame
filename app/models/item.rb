class Item < ApplicationRecord

	def use(target)
		if target
			Game.post("/items/use/#{guid}?target=#{target}")
		else
			Game.post("/items/use/#{guid}")
		end

		Item.update(status: 'Used')
	end
end
