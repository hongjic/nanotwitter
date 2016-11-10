
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

  # always be included in a transaction
  def import_followinglist_from_db follower_id
    following_list = []
    Follow.select("followed_id").where("follower_id = ?", user_id).each { |follow| following_list.push follow.followed_id }

    @redis.multi { following_list.each { |following_id| @redis.sadd FOLLOWING_SET(follower_id), following_id }}
  end

  # always be included in a transaction
  def import_followerlist_from_db following_id
    follower_list = []
    Follow.select("follower_id").where("followed_id = ?", user_id).each { |follow| follower_list.push follower_id }

    @redis.multi { follower_list.each { |follower_id| @redis.sadd FOLLOWER_SET(following_id), follower_id }} 
  end


  # always called after database has done the operation
  def delete_follow follower_id, following_id
    following_set_key = FOLLOWING_SET(follower_id)
    follower_set_key = FOLLOWER_SET(following_id)

    @redis.multi do
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
  end

  # always called after database has done the operation
  def add_follow follower_id, following_id
    following_set_key = FOLLOWING_SET(follower_id)
    follower_set_key = FOLLOWER_SET(following_id)

    @redis.multi do
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
  end

  def is_following? follower_id, following_id
    following_set_key = FOLLOWING_SET(follower_id)

    @redis.multi do
      import_followinglist_from_db follower_id unless @redis.exists following_set_key
      @is_following = @redis.sismember following_set_key, following_id
    end

    @is_following.value
  end

  # output an array of following_ids (integer)
  def get_followings follower_id
    following_set_key = FOLLOWING_SET(follower_id)
    followings = []

    @redis.multi do
      import_followinglist_from_db follower_id unless @redis.exists following_set_key
      @string_arr = @redis.smembers following_set_key
    end

    @string_arr.value.each { |id_string| followings.push id_string.to_i }
    followings
  end

  # output an array of follower_ids (integer)
  def get_followers following_id
    follower_set_key = FOLLOWER_SET(following_id)
    followers = []

    @redis.multi do
      import_followerlist_from_db following_id unless @redis.exists follower_set_key
      @string_arr = @redis.smembers follower_set_key
    end

    @string_arr.value.each { |id_string| followers.push id_string.to_i }
    followers
  end

end