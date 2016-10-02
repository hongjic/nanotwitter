class CreateNotification < ActiveRecord::Migration
  
  def up
    create_table :notifications do |t|
      t.integer :target_user_id, null: false
      t.column :type, :integer, null: false

      # the following two attributes are for type: "reply" and "mention"
        t.integer :tweet_id
        t.column :status, :integer, default: 0
        # default = 0 means default is "unread"

      # the following attribute is for type: "new_follower"
        t.integer :new_follower_id
    end

    add_foreign_key :notifications, :users, column: :target_user_id
    add_foreign_key :notifications, :tweets, column: :tweet_id
    add_foreign_key :notifications, :users, column: :new_follower_id
  end

  def down
    drop_table :notifications
  end

end
