class CreateTweet < ActiveRecord::Migration
  
  def up
    create_table :tweets do |t|
      t.integer :user_id, null: false
      t.string :content, limit: 140, null: false
      t.datetime :create_time, null: false
      t.integer :likes, default: 0, null: false
      t.integer :reply_to_tweet_id
    end
    add_foreign_key :tweets, :users, column: :user_id
    add_foreign_key :tweets, :tweets, column: :reply_to_tweet_id
  end

  def down
    drop_table :tweets
  end

end
