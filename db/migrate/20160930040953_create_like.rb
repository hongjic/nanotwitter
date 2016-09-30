class CreateLike < ActiveRecord::Migration
  def up
  	create_table :likes do |t|
		t.integer :tweet_id
		t.integer :user_id

  	end
  end

  def down
  	drop_table :likes
  end
end
