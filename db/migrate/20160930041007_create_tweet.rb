class CreateTweet < ActiveRecord::Migration
  def up
  	create_table :tweets do |t|
		t.integer :tweet_id
		t.integer :user_id
		t.datetime :create_time
		t.string :content
		t.integer :likes

  	end
  end

  def down
  	drop_table :tweets
  end
end
