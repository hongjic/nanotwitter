require 'singleton'

# will be cached in future

class SocialGraph

  include Singleton
  attr_accessor :datacache

  def initialize
    @datacache = DataCache.instance
  end

  # check whether the active user is following
  def is_following? follower_id, followed_id
    @datacache.is_following? follower_id, followed_id
  end

  def add_follow_relation follower_id, followed_id
    # change the database first, than synchronize the cache.
    t = Time.now().to_i
    follow = Follow.new
    follow.follower_id = follower_id
    follow.followed_id = followed_id
    follow.create_time = t
    follow.save

    @datacache.add_follow follower_id, followed_id
  end

  def delete_follow_relation follower_id, followed_id
    # change the database first, than synchronize the cache.
    follows = Follow.where("follower_id = ? and followed_id = ?", follower_id, followed_id)
    follows.each { |follow| follow.destroy }
    
    @datacache.delete_follow follower_id, followed_id
  end

  def find_following_id_list user_id
    @datacache.get_followings user_id
  end

  def find_follower_id_list user_id
    @datacache.get_followers user_id
  end

end