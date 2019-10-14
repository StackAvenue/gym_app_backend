class AddTrainerIdInUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :trainer_id, :integer, add_index: true
  end
end
