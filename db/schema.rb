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

ActiveRecord::Schema.define(version: 20160930041025) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "followers", force: :cascade do |t|
    t.string   "follower_id"
    t.integer  "user_id"
    t.datetime "create_time"
  end

  create_table "likes", force: :cascade do |t|
    t.integer "tweet_id"
    t.integer "user_id"
  end

  create_table "marks", force: :cascade do |t|
    t.integer "tweet_id"
    t.integer "tag_id"
  end

  create_table "models", force: :cascade do |t|
    t.string "name"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "notification_id"
    t.integer "target_user_id"
    t.integer "action_user_id"
    t.integer "tweet_id"
    t.boolean "status"
    t.boolean "type"
  end

  create_table "tags", force: :cascade do |t|
    t.integer "tweet_id"
    t.string  "tag_name"
  end

  create_table "tweets", force: :cascade do |t|
    t.integer  "tweet_id"
    t.integer  "user_id"
    t.datetime "create_time"
    t.string   "content"
    t.integer  "likes"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.string   "email"
    t.string   "password"
    t.datetime "create_time"
    t.string   "gender"
    t.date     "birthday"
  end

end
