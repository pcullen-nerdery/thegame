class AddTargetToQueuedItems < ActiveRecord::Migration[5.0]
  def change
  	add_column :queued_items, :target, :string
  end
end
