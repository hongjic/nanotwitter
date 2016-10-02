class CreateFollow < ActiveRecord::Migration
  
  def up
    create_table :follows do |t|
      t.integer :follower_id, null: false
      t.integer :followed_id, null: false
      t.datetime :create_time, null: false
    end
    add_foreign_key :follows, :users, column: :follower_id
    add_foreign_key :follows, :users, column: :followed_id
  end

  def down
    drop_table :follows
  end
end
