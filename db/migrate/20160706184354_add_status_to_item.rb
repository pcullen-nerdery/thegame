class AddStatusToItem < ActiveRecord::Migration[5.0]
  def change
  	add_column :items, :status, :string
  end
end
