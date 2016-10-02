class CreateTweetTags < ActiveRecord::Migration
  def up
    create_table :tweet_tags do |t|
      t.integer :tag_id, null: false
      t.integer :tweet_id, null: false
    end
    add_foreign_key :tweet_tags, :tweets, column: :tweet_id
    add_foreign_key :tweet_tags, :tags, column: :tag_id
  end

  def down
    drop_table :tweet_tags
  end
end
