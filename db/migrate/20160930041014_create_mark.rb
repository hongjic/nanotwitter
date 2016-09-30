class CreateMark < ActiveRecord::Migration
  def up
  	create_table :marks do |t|
		t.integer :tweet_id
		t.integer :tag_id

  	end
  end

  def down
  	drop_table :marks
  end
end
