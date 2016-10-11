class CreateTag < ActiveRecord::Migration
  def up
    create_table :tags do |t|
      t.string :tag_name, null: false
      t.integer :tweet_id, null: false
    end
    add_foreign_key :tags, :tweets, column: :tweet_id
  end

  def down
    drop_table :tags
  end
end
