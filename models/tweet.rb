class Tweet < ActiveRecord::Base
  
  class TweetValidator < ActiveModel::Validator
    def validate tweet 
      if tweet.user_id == nil
        tweet.errors[:user_id] << "Please provide the owner's id."
      elsif tweet.content == nil || tweet.content.length < 5 || tweet.content.length > 140
        tweet.errors[:content] << "Invalid tweet content."
      end
    end
  end

  has_many :likes
  has_many :users_like, :through => :likes, :source => :user

  has_many :tweet_tags
  has_many :tags, :through => :tweet_tags

  belongs_to :reply_to_tweet, :class_name => 'Tweet'
  has_many :replies, :class_name => 'Tweet', :foreign_key => :reply_to_tweet_id

  belongs_to :user

  validates_with TweetValidator

  def to_json_obj fields = nil
    obj = {}
    default = ["id", "user_id", "user_name", "content", "create_time", "favors", "reply_to_tweet_id"]
    fields ||= default
    fields.each do |key|
      obj.store(key, instance_eval("self.#{key}")) if default.include? key
    end
    obj
  end
end