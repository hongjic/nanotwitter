class CreateTweet < ActiveRecord::Migration
  
  def up
    create_table :tweets do |t|
      t.integer :user_id, null: false
      # denormalization, since a tweet can never change its owner, it won't have any bad effects.
      t.string :user_name, limit: 20, null: false
      t.string :content, limit: 140, null: false
      t.integer :create_time, limit: 8, null: false
      t.integer :favors, default: 0, null: false
      t.integer :reply_to_tweet_id
    end
    add_foreign_key :tweets, :users, column: :user_id
    add_foreign_key :tweets, :tweets, column: :reply_to_tweet_id
  end

  def down
    drop_table :tweets
  end

end
