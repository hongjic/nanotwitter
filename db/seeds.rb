# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require './models/follow'
require './models/like'
require './models/notification'
require './models/tag'
require './models/tweet'
require './models/tweet_tag'
require './models/user'

User.create(name: "user1", email: "email1", password: "111111", create_time: 1475280000, gender: "male")
User.create(name: "user2", email: "email2", password: "111111", create_time: 1475280000, gender: "male")
User.create(name: "user3", email: "email3", password: "111111", create_time: 1475280000, gender: "male")
User.create(name: "user4", email: "email4", password: "111111", create_time: 1475280000, gender: "male")
User.create(name: "user5", email: "email5", password: "222222", create_time: 1475280000)

Tweet.create(user_id: 1, user_name: "user1", content: "tweet1", create_time: 1475280000)
Tweet.create(user_id: 1, user_name: "user1", content: "tweet2", create_time: 1475366400)
Tweet.create(user_id: 2, user_name: "user2", content: "tweet3", create_time: 1475452800)
Tweet.create(user_id: 2, user_name: "user2", content: "tweet4", create_time: 1475539200, reply_to_tweet_id: 1)
Tweet.create(user_id: 3, user_name: "user3", content: "tweet5", create_time: 1475625600, reply_to_tweet_id: 1)

Follow.create(follower_id: 1, followed_id: 2, create_time: 1475452800)
Follow.create(follower_id: 1, followed_id: 3, create_time: 1475452800)
Follow.create(follower_id: 2, followed_id: 1, create_time: 1475452800)
Follow.create(follower_id: 2, followed_id: 3, create_time: 1475452800)
Follow.create(follower_id: 3, followed_id: 1, create_time: 1475452800)

Like.create(user_id: 1, tweet_id: 3);
Like.create(user_id: 1, tweet_id: 4);
Like.create(user_id: 1, tweet_id: 5);