class CreateUserDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :user_details do |t|
      t.integer :user_id, add_index: true
  	  t.decimal :height
  	  t.decimal :weight
      t.integer :age

      t.timestamps
    end
  end
end
