class QueuedItem < ApplicationRecord
	belongs_to :item

	scope :unused, -> { where("status != 'Used' or status is null") }

	def item_name
		item.name if item
	end
end
