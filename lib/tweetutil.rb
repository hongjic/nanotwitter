module TweetUtil

  include Algorithms

  # id_max means that the return tweets_id shouldn't be bigger or equal to this
  # number: the number of tweets returned.
  def get_home_line user_id, id_max, number
    homeline = HomeLine.new user_id
    tweetid_list = homeline.get_homeline
    # a list of tweetid (order uncertain)
    tweetid_list = select_top_k tweetid_list, id_max, number 
    # an ordered descend array which the max the less than id_max
    tweet_list = TweetList.new Tweet.where(id: tweetid_list).order(id: :desc)
    # postgres will only scan index, so it is quick
    tweet_list.to_json_obj
  end

  def get_global_home_line
    homeline = HomeLine.new
    homeline.get_global_homeline # a list of json obj (order certain: id descendent)
  end

  def get_time_line user_id
    timeline = TimeLine.new user_id
    tweetid_list = timeline.get_timeline # a list of tweet.id (order uncertain)
    tweet_list = TweetList.new Tweet.where(id: tweetid_list).order("id") 
    # postgres will only scan index, so it is quick
    tweet_list.to_json_obj
  end

  def create_new_tweet user, content, reply_to_tweet_id
    tweet = {"user_id" => user["id"], 
      "user_name" => user["name"], 
      "content" => content, 
      "create_time" => Time.now().to_i, 
      "favors" => 0,
      "reply_to_tweet_id" => reply_to_tweet_id }
    homeline = HomeLine.new user["id"]
    timeline = TimeLine.new user["id"]
    tweet = timeline.add_tweet tweet
    homeline.create_new_tweet tweet
    tweet
  end

  # find tweet by keyword in content
  def find_tweets_by_keyword keyword, fields
    tweets = TweetList.new Tweet.where("content LIKE ?", '%' + keyword + '%')
    tweets.to_json_obj fields
  end

  # return a json obj
  def find_tweet_by_id tweet_id
    Tweet.find(tweet_id).to_json_obj
  end

  module Test

    def random_tweet_gen no_of_tweets, user_id, user_name
      tweet_array = Array.new
      for j in 0..no_of_tweets-1 do
        content = Faker::Lorem.paragraph[1..140]
        tweet_array[j] = [user_id,user_name,content,Time.now.to_i,0,nil]
      end
      tweet_array
    end

    def create_batch_tweets tweet_rows, tweet_array
      result = Tweet.import tweet_rows, tweet_array
      ActiveRecord::Base.connection.execute("SELECT setval('tweets_id_seq', max(id)) FROM tweets")
      result
    end

    def tweet_count
      Tweet.count
    end

  end

end