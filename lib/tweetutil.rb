module TweetUtil

  def get_home_line user_id
    homeline = HomeLine.new user_id
    tweetid_list = homeline.get_homeline
    tweet_list = TweetList.new Tweet.where(id: tweetid_list)
    tweet_list.to_json_obj
  end

  def get_time_line user_id
    timeline = TimeLine.new user_id
    tweets = timeline.get_timeline # a list of [tweet.create_time, tweet.id]
    id_list = []
    tweets.each { |tweet| id_list.push tweet[1]}
    tweet_list = TweetList.new Tweet.where(id: id_list)
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
      Tweet.import tweet_rows, tweet_array
    end

    def tweet_count
      Tweet.count
    end

  end

end