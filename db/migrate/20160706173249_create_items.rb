class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.string :guid
      t.string :name
      t.integer :rarity
      t.string :description

      t.timestamps
    end
  end
end
