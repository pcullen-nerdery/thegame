class CreateEffects < ActiveRecord::Migration[5.0]
  def change
    create_table :effects do |t|
      t.datetime :occurred_at
      t.string :creator
      t.string :target
      t.string :name
      t.string :type
      t.string :vote_gain
      t.string :description
      t.text :details

      t.timestamps
    end
  end
end
