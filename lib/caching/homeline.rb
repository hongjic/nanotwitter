# This class if for caching homeline in redis

class HomeLine

  attr_accessor :datacache
  attr_accessor :tasks
  attr_accessor :user_id
  attr_accessor :key
  attr_accessor :social

  def initialize user_id
    @user_id = user_id
    @datacache = DataCache.instance
    @key = "user:#{user_id}:homeline"
    @tasks = TaskProducer.instance
    @social = SocialGraph.new user_id
  end

  # return a list of tweetid (order uncertain)
  def get_homeline 
    return @datacache.smembers @key if @datacache.exists @key
    tweetid_list = get_homeline_db # a list of tweet.id
    @datacache.sadd @key, tweetid_list
    tweetid_list
  end

  # return true/false
  def add_follow following_id
    timeline = TimeLine.new following_id
    tweetid_list = timeline.get_timeline # a list of tweet.id
    @tasks.new_task("homeline:update", "add_follow", {user_id: @user_id, timeline: tweetid_list})
  end

  # return true/false
  def delete_follow following_id
    timeline = TimeLine.new following_id
    tweetid_list = timeline.get_timeline # a list of tweet.id
    @tasks.new_task("homeline:update", "delete_follow", {user_id: @user_id, timeline: tweetid_list})
  end

  # return true/false
  # input is a json object
  def create_new_tweet tweet
    userid_list = @social.get_follower_list
    userid_list.push @user_id
    @tasks.new_task("homeline:update", "create_new_tweet", {userid_list: userid_list, tweetid: tweet["id"] })
  end

  private
    # return a list of tweet.id
    def get_homeline_db
      userid_list = @social.get_following_list
      userid_list.push @user_id
      
      tweetid_list = []
      Tweet.select("id").where(user_id: userid_list).each {|tweet| tweetid_list.push tweet.id }
      tweetid_list
    end
end