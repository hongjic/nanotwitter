class User < ActiveRecord::Base
  has_many :followers
  has_many :tweets
  has_many :notifications
end