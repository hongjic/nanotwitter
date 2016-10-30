require 'singleton'

# will be cached in future

class SocialGraph

  include Singleton

  # check whether the active user is following
  def is_following? follower_id, followed_id
    !Follow.where("follower_id = ? and followed_id = ? ", follower_id, followed_id).empty?
  end

  def add_follow_relation follower_id, followed_id
    t = Time.now().to_i
    follow = Follow.new 
    follow.follower_id = follower_id
    follow.followed_id = followed_id
    follow.create_time = t
    follow.save
  end

  def delete_follow_relation follower_id, followed_id
    follows = Follow.where("follower_id = ? and followed_id = ?", follower_id, followed_id)
    follows.each do |follow|
      follow.destroy
    end
  end

  def find_following_id_list user_id
    userid_list = []
    Follow.select("followed_id").where("follower_id = ?", user_id).each do |follow|
      userid_list.push follow.followed_id
    end
    userid_list
  end

  def find_follower_id_list user_id
    userid_list = []
    Follow.select("follower_id").where("followed_id = ?", user_id).each do |follow|
      userid_list.push follow.follower_id
    end
    userid_list
  end

end