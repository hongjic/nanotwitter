class CreateUser < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :name, limit: 20, null: false, index: {unique: true}
      t.string :email, limit: 45, null: false, index: {unique: true}
      t.string :password, limit: 20, null: false
      t.datetime :create_time, null: false
      t.column :gender, :integer, default: 0, null: false
      t.date :birthday
    end
  end

  def down
    drop_table :users
  end
end