# This class if for caching homeline in redis

class HomeLine

  attr_accessor :datacache
  attr_accessor :tasks
  attr_accessor :user_id
  attr_accessor :key
  attr_accessor :social

  def initialize user_id = nil
    @datacache = DataCache.instance
    if (user_id == nil)
      @global_key = "global:homeline"
    else
      @user_id = user_id
      @key = "user:#{user_id}:homeline"
      @tasks = TaskProducer.instance
      @social = SocialGraph.new user_id
    end
  end

  # return a list of tweetid (order uncertain)
  def get_homeline
    return @datacache.smembers @key if @datacache.exists @key
    puts "get homeline from db"
    tweetid_list = get_homeline_db # a list of tweet.id
    @datacache.sadd @key, tweetid_list if !tweetid_list.empty?
    tweetid_list
  end

  # return a list of tweet(json obj) (order certain, id desendent)
  def get_global_homeline
    return @datacache.get @global_key if @datacache.exists @global_key
    global_homeline = get_global_homeline_db # a list of tweet (json obj)
    @datacache.set @global_key, global_homeline
    global_homeline
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
    @tasks.new_task("homeline:update", "create_new_tweet", {userid_list: userid_list, tweet: tweet })
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

    # return a list of tweet(json obj)
    def get_global_homeline_db
      tweets = []
      Tweet.order(id: :desc).limit(50).each { |record| tweets.push record.to_json_obj }
      tweets
    end
end