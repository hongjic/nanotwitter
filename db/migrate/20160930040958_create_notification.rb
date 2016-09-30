class CreateNotification < ActiveRecord::Migration
  def up
  	create_table :notifications do |t|
		t.integer :notification_id
		t.integer :target_user_id
		t.integer :action_user_id
		t.integer :tweet_id
		t.boolean :status
		t.boolean :type

  	end
  end

  def down
  	drop_table :notifications
  end
end
