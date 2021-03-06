# All the logics related to the social relationships is defined and implemented here to make it easy to 
# scale in the future (become a separate service).

class SocialGraph

  # in redis is a JSON string, represents a set of ids in memory.
  # O(lgn) to query is_following?
  # O(n) to add or delete following
  # O(1) to get following_list
  include Algorithms

  attr_accessor :datacache
  attr_accessor :user_id
  attr_accessor :followings_key
  attr_accessor :followers_key

  def initialize user_id
    @datacache = DataCache.instance
    @user_id = user_id
    @followings_key = "user:#{user_id}:followings"
    @followers_key = "user:#{user_id}:followers"
  end

  # check whether the user is following following_id
  def is_following? following_id
    following_list = get_following_list
    index = index_of_last_LE(following_list, following_id)
    return true if (following_list[index] == following_id) 
    false
  end

  # return true/false
  def add_follow following_id
    # first update the db
    success = add_follow_db following_id
    return false if !success
    # update the cache
    following_list = get_following_list
    sg2 = SocialGraph.new following_id
    follower_list = sg2.get_follower_list
    @datacache.multi {
      add_following_cache following_list, following_id
      sg2.add_follower_cache follower_list, @user_id
    }
    true
  end

  # return true/false
  def delete_follow following_id
    # first update the db
    success = delete_follow_db following_id
    return false if !success
    # update the cache
    following_list = get_following_list
    sg2 = SocialGraph.new following_id
    follower_list = sg2.get_follower_list
    @datacache.multi {
      delete_following_cache following_list, following_id
      sg2.delete_follower_cache follower_list, @user_id
    }
    true
  end

  # return a list
  def get_following_list
    following_list = @datacache.get @followings_key
    return following_list if following_list != nil
    # not exists, then get from db and import
    following_list = get_followings_db # a list
    @datacache.set @followings_key, following_list
    following_list
  end

  # return a list
  def get_follower_list
    follower_list = @datacache.get @followers_key
    return follower_list if follower_list != nil
    # not exists, then get from db and import
    follower_list = get_followers_db # a list
    @datacache.set @followers_key, follower_list
    follower_list
  end

  protected 
    def add_following_cache following_list, following_id
      insert_index = index_of_last_LE(following_list, following_id)
      if following_list[insert_index] != following_id 
        following_list.insert insert_index, following_id
        @datacache.set @followings_key, following_list
      end
    end

    def add_follower_cache follower_list, follower_id
      insert_index = index_of_last_LE(follower_list, follower_id)
      if follower_list[insert_index] != follower_id
        follower_list.insert insert_index, follower_id
        @datacache.set @followers_key, follower_list
      end
    end

    def delete_following_cache following_list, following_id
      delete_index = index_of_last_LE(following_list, following_id)
      if following_list[delete_index] == following_id
        following_list.delete_at delete_index
        @datacache.set @followings_key, following_list
      end
    end

    def delete_follower_cache follower_list, follower_id
      delete_index = index_of_last_LE(follower_list, follower_id)
      if follower_list[delete_index] == follower_id
        follower_list.delete_at delete_index
        @datacache.set @followers_key, follower_list
      end
    end

  private
    # return a sorted list
    def get_followings_db
      following_list = []
      records = Follow.select("followed_id").where("follower_id = ?", @user_id).order("followed_id")
      records.each { |follow| following_list.push follow.followed_id }
      following_list
    end

    # return a sorted list
    def get_followers_db
      follower_list = []
      records = Follow.select("follower_id").where("followed_id = ?", @user_id).order("follower_id")
      records.each { |follow| follower_list.push follow.follower_id }
      follower_list
    end

    # return true/false
    def add_follow_db following_id
      begin
        Follow.create(follower_id: @user_id, followed_id: following_id, create_time: Time.now().to_i)
        true
      rescue ActiveRecord::InvalidForeignKey 
        false
      end
    end

    # return true/false
    def delete_follow_db following_id
      begin
        Follow.find_by(follower_id: @user_id, followed_id: following_id).destroy
        true
      rescue ActiveRecord::RecordNotFound
        false
      end
    end

end