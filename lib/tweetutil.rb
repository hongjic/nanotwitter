module TweetUtil

  class TweetList
    # ActiveRecord::Relation
    attr_accessor :tweets_relation

    def initialize tweets
      @tweets_relation = tweets
    end

    def to_json_obj fields = nil
      list = [];
      @tweets_relation.each do |tweet_record|
        list.push(tweet_record.to_json_obj fields)
      end
      list
    end
  end

  def get_home_line user
    userid_list = []
    Follow.select("followed_id").where("follower_id = ?", user.id).each do |follow|
      userid_list.push follow.followed_id
    end
    userid_list.push user.id
    tweet_list = TweetList.new Tweet.where(user_id: userid_list)
    tweet_list.to_json_obj
  end

  def create_new_tweet user, content, reply_to_tweet_id
    tweet = Tweet.new
    tweet.user_id = user.id
    tweet.user_name = user.name
    tweet.content = content
    tweet.create_time = Time.now().getutc.to_i
    tweet.favors = 0
    tweet.reply_to_tweet_id = reply_to_tweet_id
    # TODO: handle with mention and reply notification and tag creation
    raise Error::TweetError, tweet.errors.messages.values[0][0] unless tweet.save
    tweet
  end

  # find tweet by keyword in content
  def find_tweets_by_keyword keyword, fields
    tweets = TweetList.new Tweet.where("content LIKE ?", '%' + keyword + '%')
    tweets.to_json_obj fields
  end

end