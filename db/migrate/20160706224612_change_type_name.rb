class ChangeTypeName < ActiveRecord::Migration[5.0]
  def change
  	rename_column :effects, :type, :effect_type
  end
end
