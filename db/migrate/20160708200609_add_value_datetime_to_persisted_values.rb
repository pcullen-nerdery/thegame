class AddValueDatetimeToPersistedValues < ActiveRecord::Migration[5.0]
  def change
    add_column :persisted_values, :value_datetime, :datetime
  end
end
