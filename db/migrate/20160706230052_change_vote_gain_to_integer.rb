class ChangeVoteGainToInteger < ActiveRecord::Migration[5.0]
  def change
  	change_column :effects, :vote_gain, 'integer USING CAST(vote_gain AS integer)'
  end
end
