
class DataCache

  # ENV["REDIS_READ"] switches read on&off
  # ENV["REDIS_WRITE"] switches write on&off

  include Singleton
  attr_accessor :redis
  
  def initialize 
    @redis = Redis.new
  end

  def get key
    st = @redis.get key
    return nil if (st == nil)
    JSON.parse(st)
  end

  def set key, value
    @redis.set key, value.to_json
  end

end