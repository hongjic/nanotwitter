class CreateTag < ActiveRecord::Migration
  def up
    create_table :tags do |t|
      t.string :tag_name, limit: 20, null: false
    end
  end

  def down
    drop_table :tags
  end
end