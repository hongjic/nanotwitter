class Tweet < ActiveRecord::Base
  has_many :likes
  has_many :users_like, :through => :likes, :source => :user

  has_many :tweet_tags
  has_many :tags, :through => :tweet_tags

  belongs_to :reply_to_tweet, :class_name => 'Tweet'
  has_many :replies, :class_name => 'Tweet', :foreign_key => :reply_to_tweet_id

  belongs_to :user

end