class QueuedItem < ApplicationRecord
	belongs_to :item

	scope :unused, -> { where("status != 'Used' or status is null") }
end
