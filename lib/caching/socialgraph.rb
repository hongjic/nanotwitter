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
    # # update the cache
    following_list = get_following_list
    insert_index = index_of_last_LE(following_list, following_id)
    if following_list[insert_index] != following_id 
      following_list.insert insert_index, following_id
      @datacache.set @followings_key, following_list
    end
    true
  end

  # return true/false
  def delete_follow following_id
    # first update the db
    success = delete_follow_db following_id
    return false if !success
    # update the cache
    following_list = get_following_list
    delete_index = index_of_last_LE(following_list, following_id)
    if following_list[delete_index] == following_id
      following_list.delete_at delete_index
      @datacache.set @followings_key, following_list
    end
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

  private

    # return a sorted list
    def get_followings_db
      following_list = []
      Follow.select("followed_id").where("follower_id = ?", @user_id).each { |follow| following_list.push follow.followed_id }
      following_list.sort
    end

    # return a sorted list
    def get_followers_db
      follower_list = []
      Follow.select("follower_id").where("followed_id = ?", @user_id).each { |follow| follower_list.push follow.follower_id }
      follower_list.sort
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