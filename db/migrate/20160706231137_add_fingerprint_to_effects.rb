class AddFingerprintToEffects < ActiveRecord::Migration[5.0]
  def change
    add_column :effects, :fingerprint, :string
    add_index :effects, :fingerprint
  end
end
