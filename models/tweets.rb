class Tweet < ActiveRecord::Base
  belongs_to :users
  has_many :notifications
  has_many :likes
  has_many :marks
  has_many :tags, through: :marks
end