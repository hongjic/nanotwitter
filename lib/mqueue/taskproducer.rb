require 'singleton'

class TaskProducer

  include Singleton

  def initialize
    conn = Bunny.new(ENV["RABBITMQ_BIGWIG_URL"])
    conn.start

    @ch = conn.create_channel
  end

  def new_task queue_name, method, params
    q = @ch.queue queue_name
    q.publish serialize(method, params)
  end

  def serialize method, params
    obj = {method: method, params: params}
    obj.to_json
  end

end