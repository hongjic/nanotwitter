class CreateFollower < ActiveRecord::Migration
  def up
  	create_table :followers do |t|
  	t.string :follower_id
		t.integer :user_id
		t.datetime :create_time

  	end
  end

  def down
  	drop_table :followers
  end
end
