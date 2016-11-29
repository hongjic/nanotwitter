# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161002053959) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "follows", force: :cascade do |t|
    t.integer "follower_id", null: false
    t.integer "followed_id", null: false
    t.integer "create_time", null: false
  end

  create_table "likes", force: :cascade do |t|
    t.integer "user_id",  null: false
    t.integer "tweet_id", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "target_user_id",              null: false
    t.integer "type",                        null: false
    t.integer "tweet_id"
    t.integer "status",          default: 0
    t.integer "new_follower_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string  "tag_name", null: false
    t.integer "tweet_id", null: false
  end

  create_table "tweets", force: :cascade do |t|
    t.integer "user_id",                                   null: false
    t.string  "user_name",         limit: 20,              null: false
    t.string  "content",           limit: 140,             null: false
    t.integer "create_time",                               null: false
    t.integer "favors",                        default: 0, null: false
    t.integer "reply_to_tweet_id"
  end

  create_table "users", force: :cascade do |t|
    t.string  "name",        limit: 20,             null: false
    t.string  "email",       limit: 45,             null: false
    t.string  "password",    limit: 20,             null: false
    t.integer "create_time",                        null: false
    t.integer "gender",                 default: 0, null: false
    t.date    "birthday"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["name"], name: "index_users_on_name", unique: true, using: :btree

  add_foreign_key "follows", "users", column: "followed_id"
  add_foreign_key "follows", "users", column: "follower_id"
  add_foreign_key "likes", "tweets"
  add_foreign_key "likes", "users"
  add_foreign_key "notifications", "tweets"
  add_foreign_key "notifications", "users", column: "new_follower_id"
  add_foreign_key "notifications", "users", column: "target_user_id"
  add_foreign_key "tags", "tweets"
  add_foreign_key "tweets", "tweets", column: "reply_to_tweet_id"
  add_foreign_key "tweets", "users"
end
