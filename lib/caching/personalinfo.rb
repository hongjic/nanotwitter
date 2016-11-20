# this class is for caching personal info and favor tweetids 
# caching format: "user:id:info"(JSON string), "user:id:favor_tweets"(JSON string from list, but APIs return set)
# if we use set for "user:id:favor_tweets", we can't tell the difference between 
# "empty set" and "set not exists". so we use string instead. When it is empty, its value is "[]"

class PersonalInfo

  # in Redis, favor_tweets is a string represent a list, ordered by Like.id, so don't need to do extra sort

  # O(1) to insert new favor_tweet
  # O(n) to delete favor_tweet
  # O(1) to get all favor_tweets
  attr_accessor :datacache
  attr_accessor :user_id
  attr_accessor :info_key
  attr_accessor :favor_key

  def initialize user_id
    @datacache = DataCache.instance
    @user_id = user_id
    @info_key = "user:#{user_id}:info"
    @favor_key = "user:#{user_id}:favor_tweets"
  end

  def get_personal_info
    byebug
    personal_info = @datacache.get @info_key
    return personal_info if personal_info != nil 
    # not exists
    personal_info = get_personal_info_db
    @datacache.set @info_key, personal_info
    personal_info
  end

  # return new info
  def update_personal_info info
    # first update the db
    personal_info = update_personal_info_db info
    # put new data into cache.
    @datacache.set @info_key, personal_info
    personal_info
  end

  #return a list
  def get_favor_tweetids
    # get 
    favor_tweetids = @datacache.get @favor_key # this is a list
    return favor_tweetids if favor_tweetids != nil
    # not exists, then import from db
    favor_tweetids = get_favor_tweetids_db # a list
    @datacache.set @favor_key, favor_tweetids 
    favor_tweetids
  end

  # return  success => favors / error => false
  def add_favor_tweet tweet_id
    # first update the db
    favors = add_favor_tweet_db tweet_id
    return false if !favors
    # get data( from cache, if doesn't hit, go to db), update and set new
    favor_tweetids = get_favor_tweetids # a list
    if favor_tweetids.last != tweet_id 
    # if last == tweet_id, means the data is get from db, it is new
    # and there can't be other favor_tweet added to the end of list in the mean while
    # because this belong to one user, user operations can not be concurrent
      favor_tweetids.push tweet_id
      @datacache.set @favor_key, favor_tweetids
    end
    favors
  end

  # return  success => favors / error => false
  def delete_favor_tweet tweet_id
    # first update the db
    favors = delete_favor_tweet_db tweet_id
    return false if !favors
    # get data (from cache, if doesn't hit, go to db), update and set new
    favor_tweetids = get_favor_tweetids # a list
    delete_index = favor_tweetids.find_index tweet_id
    if delete_index != nil
      favor_tweetids.delete_at delete_index
      @datacache.set @favor_key, favor_tweetids
    end
    favors
  end

  private

    def get_personal_info_db
      user = User.find @user_id
      user.to_json_obj
    end

    # update the record in db and return the new
    def update_personal_info_db info
      begin
        user = User.find @user_id
        return user.to_json_obj if user.update(info)
        raise Error::UserUpdateError, user.errors.messages.values[0][0]
      rescue ActiveModel::UnknownAttributeError
        raise Error::UserUpdateError, "UnknownAttributeError"
      end
    end

    # return a list ( ordered by like.id, so don't need to sort )
    def get_favor_tweetids_db
      tweet_ids = []
      records = Like.select("tweet_id").where(user_id: @user_id)
      records.each { |record| tweet_ids.push record.tweet_id }
      tweet_ids
    end

    def add_favor_tweet_db tweet_id
      begin
        tweet = Tweet.find tweet_id
        ActiveRecord::Base.transaction do
          Like.create(user_id: @user_id, tweet_id: tweet_id)
          tweet.update(favors: tweet.favors + 1)
        end
        tweet.favors
      rescue ActiveRecord::InvalidForeignKey, ActiveRecord::RecordNotFound => e
        false
      end
    end

    def delete_favor_tweet_db tweet_id
      begin
        tweet = Tweet.find tweet_id
        ActiveRecord::Base.transaction do
          like = Like.find_by(tweet_id: tweet_id, user_id: @user_id)
          like.destroy
          tweet.update(favors: tweet.favors - 1)
        end
        tweet.favors
      rescue ActiveRecord::RecordNotFound => e
        false
      end
    end

end