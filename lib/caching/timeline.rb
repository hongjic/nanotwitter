# This class is for caching time line in Redis. 
# key: "user:id:timeline", value: a JSON string represents a list
# The tweets is ordered chronologically (same meanning as "ordered by tweet_id")
# O(1) time to post a tweet
# O(1) time to get all

class TimeLine

  attr_accessor :datacache
  attr_accessor :user_id
  attr_accessor :key

  def initialize user_id
    @user_id = user_id
    @datacache = DataCache.instance
    @key = "user:#{user_id}:timeline"
  end

  # return a list of [tweet.create_time, tweet.id]
  def get_timeline 
    # get from cache
    timeline = @datacache.get @key
    return timeline if timeline != nil
    # not exists get from db and import
    timeline = get_timeline_db
    @datacache.set @key, timeline
    timeline
  end

  # will throw an TweetError if create new tweet fails
  # return a tweet(json obj)
  def add_tweet tweetinfo
    # first update db
    tweet = add_tweet_db tweetinfo
    # update cache
    timeline = get_timeline
    if timeline.last[1] != tweet.id
      timeline.push [tweet.create_time, tweet.id]
      @datacache.set @key, timeline
    end
    tweet.to_json_obj
    # TODO: handle with mention and reply notification and tag creation
  end

  private

    #return a list of [tweet.create_time, tweet.id]
    def get_timeline_db
      timeline = []
      tweets = Tweet.select("create_time", "id").where("user_id = ?", @user_id).order("create_time")
      tweets.each { |tweet| timeline.push [tweet.create_time, tweet.id] }
      timeline
    end

    def add_tweet_db tweetinfo
      begin
        tweet = Tweet.create tweetinfo
        raise Error::TweetError, tweet.errors.messages.values[0][0] unless tweet.persisted?
        tweet
      rescue ActiveModel::UnknownAttributeError
        raise Error::TweetError, "UnknownAttributeError"
      end
    end

end