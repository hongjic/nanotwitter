class TweetList
  # ActiveRecord::Relation
  attr_accessor :tweets_relation
  attr_accessor :tweet_list

  def initialize tweets
    @tweets_relation = tweets
  end

  def to_json_obj fields = nil
    # memorization
    return @tweet_list if @tweet_list != nil
    
    @tweet_list = []
    @tweets_relation.each do |tweet_record|
      @tweet_list.push(tweet_record.to_json_obj fields)
    end
    @tweet_list
  end
end