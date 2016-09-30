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

ActiveRecord::Schema.define(version: 20160930040949) do

  create_table "comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "tweet_id",                  null: false
    t.integer  "user_id",                   null: false
    t.text     "content",     limit: 65535, null: false
    t.datetime "create_time",               null: false
    t.index ["tweet_id"], name: "tweet_id_in_comments_idx", using: :btree
    t.index ["user_id"], name: "user_id_in_comments_idx", using: :btree
  end

  create_table "followers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "follower_id"
    t.integer  "user_id"
    t.datetime "create_time"
  end

  create_table "follows", primary_key: ["follower_id", "followed_id"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "follower_id", null: false
    t.integer  "followed_id", null: false
    t.datetime "create_time", null: false
    t.index ["followed_id"], name: "followed_id_idx", using: :btree
    t.index ["follower_id"], name: "follower_id_idx", using: :btree
  end

  create_table "likes", primary_key: ["user_id", "tweet_id"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id",  null: false
    t.integer "tweet_id", null: false
    t.index ["tweet_id"], name: "tweet_id_in_likes_idx", using: :btree
    t.index ["user_id"], name: "user_id_in_likes_idx", using: :btree
  end

  create_table "notifications", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "target_user_id",                              null: false
    t.integer "tweet_id",                                    null: false
    t.string  "status",         limit: 6, default: "unread", null: false
    t.string  "type",           limit: 7,                    null: false
    t.integer "action_user_id",                              null: false
    t.index ["action_user_id"], name: "action_user_id_idx", using: :btree
    t.index ["target_user_id"], name: "target_user_id_idx", using: :btree
    t.index ["tweet_id"], name: "tweet_id_idx", using: :btree
  end

  create_table "tags", primary_key: ["tag_name", "tweet_id"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "tag_name", limit: 20, null: false
    t.integer "tweet_id",            null: false
    t.index ["tag_name"], name: "tag_name_idx", using: :btree
    t.index ["tweet_id"], name: "tweet_id_idx", using: :btree
  end

  create_table "tweets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id",                               null: false
    t.integer  "likes",                     default: 0, null: false
    t.text     "content",     limit: 65535,             null: false
    t.datetime "create_time",                           null: false
    t.integer  "comments",                  default: 0, null: false
    t.index ["user_id"], name: "user_id_idx", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",        limit: 20,                     null: false
    t.string   "email",       limit: 45,                     null: false
    t.string   "passwd",      limit: 20,                     null: false
    t.datetime "create_time",                                null: false
    t.string   "gender",      limit: 7,  default: "unknown", null: false
    t.datetime "birthday"
    t.index ["email"], name: "email_UNIQUE", unique: true, using: :btree
    t.index ["name"], name: "name_UNIQUE", unique: true, using: :btree
  end

  add_foreign_key "comments", "tweets", name: "tweet_id_in_comments"
  add_foreign_key "comments", "users", name: "user_id_in_comments"
  add_foreign_key "follows", "users", column: "followed_id", name: "followed_id", on_update: :cascade, on_delete: :cascade
  add_foreign_key "follows", "users", column: "follower_id", name: "follower_id", on_update: :cascade, on_delete: :cascade
  add_foreign_key "likes", "tweets", name: "tweet_id_in_likes"
  add_foreign_key "likes", "users", name: "user_id_in_likes"
  add_foreign_key "notifications", "tweets", name: "tweet_id_in_notifications"
  add_foreign_key "notifications", "users", column: "action_user_id", name: "action_user_id"
  add_foreign_key "notifications", "users", column: "target_user_id", name: "target_user_id"
  add_foreign_key "tags", "tweets", name: "tweet_id_in_tags", on_update: :cascade, on_delete: :cascade
  add_foreign_key "tweets", "users", name: "user_id", on_update: :cascade, on_delete: :cascade
end
