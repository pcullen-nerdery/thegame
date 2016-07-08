class CreatePersistedValues < ActiveRecord::Migration[5.0]
  def change
    create_table :persisted_values do |t|
      t.string :key
      t.string :value

      t.timestamps
    end
  end
end
