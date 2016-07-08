class CreateQueuedItems < ActiveRecord::Migration[5.0]
  def change
    create_table :queued_items do |t|
      t.integer :item_id
      t.string :status
      t.integer :location

      t.timestamps
    end
  end
end
