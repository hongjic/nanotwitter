#   This class is thread safe, but there is a slight possiblity that it will do
# redundant database query to import data or get a wrong result due to 
# data expiration in the process (but doesn't affect the following requests).
#   Redis's multi and watch doesn't help this, and although adding Mutex can solve this
# problem in a process, it can still happen when the application has two or more web dynos.
#   So the ultimate solution is to use a queue to handle the coming requests and force 
# the synchronous execution (but then it may affect the performance slightly)

class DataCache

  include Singleton
  attr_accessor :redis
  
  def initialize 
    @redis = Redis.new
  end

  def FOLLOWING_SET follower_id
    "user:#{follower_id}:followings"
  end

  def FOLLOWER_SET following_id
    "user:#{following_id}:followers"
  end

  def import_followinglist_from_db follower_id
    puts "DATABASE import #{FOLLOWING_SET(follower_id)}"
    following_list = []
    Follow.select("followed_id").where("follower_id = ?", follower_id).each { |follow| following_list.push follow.followed_id }

    @redis.multi do
      following_list.each { |following_id| @redis.sadd FOLLOWING_SET(follower_id), following_id }
    end
  end

  def import_followerlist_from_db following_id
    puts "DATABASE import #{FOLLOWER_SET(following_id)}"
    follower_list = []
    Follow.select("follower_id").where("followed_id = ?", following_id).each { |follow| follower_list.push follow.follower_id }
    
    @redis.multi do
      follower_list.each { |follower_id| @redis.sadd FOLLOWER_SET(following_id), follower_id }
    end
  end


  # always called after database has done the operation
  # there is a slight possiblitity the data expired just after @redis.srem and
  # import_followinglist_from_db/import_followerlist_from_db being called multiple times 

  def delete_follow follower_id, following_id
    following_set_key = FOLLOWING_SET(follower_id)
    follower_set_key = FOLLOWER_SET(following_id)
    
    if @redis.exists following_set_key
      @redis.srem following_set_key, following_id
    else
      import_followinglist_from_db follower_id
    end
    if @redis.exists follower_set_key
      @redis.srem follower_set_key, follower_id
    else
      import_followerlist_from_db following_id
    end

  end

  # always called after database has done the operation
  # there is a slight possiblitity the data expired just after @redis.sadd and
  # import_followinglist_from_db/import_followerlist_from_db being called multiple times 

  def add_follow follower_id, following_id
    following_set_key = FOLLOWING_SET(follower_id)
    follower_set_key = FOLLOWER_SET(following_id)

    if @redis.exists following_set_key
      @redis.sadd following_set_key, following_id
    else
      import_followinglist_from_db follower_id
    end
    if @redis.exists follower_set_key
      @redis.sadd follower_set_key, follower_id
    else
      import_followerlist_from_db following_id
    end

  end

  # there is a slight possiblitity the data expired just after @redis.exists and
  # import_followinglist_from_db being called multiple times

  def is_following? follower_id, following_id
    following_set_key = FOLLOWING_SET(follower_id)

    import_followinglist_from_db follower_id unless @redis.exists following_set_key
    @is_following = @redis.sismember following_set_key, following_id

    @is_following
  end

  # output an array of following_ids (integer)
  # there is a slight possiblitity the data expired just after @redis.exists and
  # import_followinglist_from_db being called multiple times

  def get_followings follower_id
    following_set_key = FOLLOWING_SET(follower_id)
    followings = []

    import_followinglist_from_db follower_id unless @redis.exists following_set_key
    string_arr = @redis.smembers following_set_key

    string_arr.each { |id_string| followings.push id_string.to_i }
    followings
  end

  # output an array of follower_ids (integer)
  # there is a slight possiblitity the data expired just after @redis.exists and
  # import_followerlist_from_db being called multiple times

  def get_followers following_id
    follower_set_key = FOLLOWER_SET(following_id)
    followers = []

    import_followerlist_from_db following_id unless @redis.exists follower_set_key
    @string_arr = @redis.smembers follower_set_key

    @string_arr.each { |id_string| followers.push id_string.to_i }
    followers
  end

end