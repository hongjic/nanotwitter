class CreateUser < ActiveRecord::Migration
  def up
  	create_table :users do |t|
  	t.string :name
		t.integer :user_id
		t.string :email
		t.string :password
		t.datetime :create_time
		t.string :gender
		t.date :birthday

  	end
  end

  def down
  	drop_table :users
  end
end
