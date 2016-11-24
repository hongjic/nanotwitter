class Notification < ActiveRecord::Base

  belongs_to :target_user, :class_name => 'User'
  belongs_to :tweet
  belongs_to :new_follower, :class_name => 'User'

  enum type: { mention: 0, reply: 1, new_follower: 2 }
  enum status: { unread: 0, read: 1 }

  def to_json_obj fields = nil
    obj = {}
    default = ["id", "target_user_id", "type", "tweet_id", "status", "new_follower_id"]
    fields ||= default
    fields.each do |key|
      obj.store(key, instance_eval("self.#{key}")) if default.include? key
    end
    obj
  end
end