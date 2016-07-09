class Item < ApplicationRecord
	scope :current_game, -> { where("status != 'Previous Game' or status is null") }
	scope :unused, -> { where("status != 'Used' or status is null") }

	class NoSuchItem < RuntimeError
	end


	def self.item_recently_used?
		item_last_used = PersistedValue.find_or_create_by(key: 'item_last_used')

		if item_last_used.value_datetime && item_last_used.value_datetime > 1.minute.ago
			return "You used an item at #{item_last_used.value_datetime.to_s}. Wait #{item_last_used.value_datetime.in_time_zone.to_i - 1.minute.ago.in_time_zone.to_i} seconds"
		end

		return false
	end

	def use!(target = nil)
		if target
			result = ::Game.post("/items/use/#{guid}?target=#{target}")
		else
			result = ::Game.post("/items/use/#{guid}")
		end
		self.update(status: 'Used')

		if result.to_s.include?("No such item found") || result.to_s.include?("Invalid item")
			another_item_to_try = Item.unused.where(name: name).first
			if another_item_to_try
				Rails.logger.info "tried using #{name}. will try another."
				another_item_to_try.use!
			else
				Rails.logger.info "tried using #{name}.  there are no others, giving up."
				raise Exceptions::NoSuchItem
			end
		end

		item_last_used = PersistedValue.find_or_initialize_by(key: 'item_last_used')
		item_last_used.value_datetime = Time.now
		item_last_used.save

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
