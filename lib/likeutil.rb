require 'set'

module LikeUtil

  # return success => favors / error => false
  def add_user_like user_id, tweet_id
    personalinfo = PersonalInfo.new user_id
    favors = personalinfo.add_favor_tweet tweet_id
  end

  # return success => favors / error => false
  def delete_user_like user_id, tweet_id
    personalinfo = PersonalInfo.new user_id
    favors = personalinfo.delete_favor_tweet tweet_id
  end

  def get_favor_tweets user_id
    tweetids = get_favor_tweetids user_id
    tweetlist = TweetList.new Tweet.where(id: tweetids)
    tweetlist.to_json_obj
  end

  # return a list of ids
  def get_favor_tweetids user_id
    personalinfo = PersonalInfo.new user_id
    personalinfo.get_favor_tweetids
  end

  # return a marked list of tweets 
  def mark_favor_on_tweets tweets, user_id
    favor_tweetids = get_favor_tweetids(user_id).to_set
    tweets.each { |tweet| tweet["is_favored"] = favor_tweetids.member? tweet["id"] }
    tweets
  end

end