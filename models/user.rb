class User < ActiveRecord::Base

  has_many :be_followeds, :class_name => 'Follow', :foreign_key => :followed_id
  has_many :followers, :through => :be_followeds, :source => :follower

  has_many :follows, :class_name => 'Follow', :foreign_key => :follower_id
  has_many :followings, :through => :follows, :source => :followed

  has_many :likes
  has_many :liked_tweets, :through => :likes, :source => :tweet

  has_many :tweets

  enum gender: { unknown: 0, male: 1, female: 2 }

end