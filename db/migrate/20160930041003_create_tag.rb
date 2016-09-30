class CreateTag < ActiveRecord::Migration
  def up
  	create_table :tags do |t|
		t.integer :tweet_id
		t.string :tag_name

  	end
  end

  def down
  	drop_table :tags
  end
end
