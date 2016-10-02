class CreateLike < ActiveRecord::Migration
  
  def up
    create_table :likes do |t|
      t.integer :user_id, null: false
      t.integer :tweet_id, null: false
    end
    add_foreign_key :likes, :users
    add_foreign_key :likes, :tweets
  end

end
