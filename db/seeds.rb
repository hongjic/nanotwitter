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
require 'byebug'


User.create(name: "user1", email: "email1", password: "111111", create_time: "2016/10/2", gender: "male")
User.create(name: "user2", email: "email1", password: "111111", create_time: "2016/10/2", gender: "male")
User.create(name: "user3", email: "email1", password: "111111", create_time: "2016/10/2", gender: "male")
User.create(name: "user4", email: "email1", password: "111111", create_time: "2016/10/2", gender: "male")

Tweet.create(user_id: 1, content: "tweet1", create_time: "2016/10/3")
Tweet.create(user_id: 1, content: "tweet2", create_time: "2016/10/3")
Tweet.create(user_id: 2, content: "tweet3", create_time: "2016/10/3")
Tweet.create(user_id: 2, content: "tweet4", create_time: "2016/10/3", reply_to_tweet_id: 1)
Tweet.create(user_id: 3, content: "tweet5", create_time: "2016/10/3", reply_to_tweet_id: 1)

Follow.create(follower_id: 1, followed_id: 2, create_time: "2016/10/3")
Follow.create(follower_id: 1, followed_id: 3, create_time: "2016/10/3")
Follow.create(follower_id: 2, followed_id: 1, create_time: "2016/10/3")
Follow.create(follower_id: 2, followed_id: 3, create_time: "2016/10/3")
Follow.create(follower_id: 3, followed_id: 1, create_time: "2016/10/3")
byebug