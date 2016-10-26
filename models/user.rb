class User < ActiveRecord::Base

  class UserValidator < ActiveModel::Validator
    def validate user 
      if user.name == nil
        user.errors[:name] << "Please provide your user name."
      elsif user.name.length < 3 || user.name.length > 20
        user.errors[:name] << "User name should be longer than 5 and shorter than 20."
      elsif (User.find_by name: user.name) != nil
        user.errors[:name] << "User name already exists."
      elsif user.password == nil || user.password.length < 6 || user.password.length > 20
        user.errors[:password] << "Password should be longer than 6 and shorter than 20."
      elsif user.email == nil
        user.errors[:email] << "Please provide your email."
      elsif (User.find_by email: user.email) != nil
        user.errors[:email] << "Email has already been used."
      elsif (user.gender == nil || (user.gender != "male" && user.gender != "female" && user.gender != "unknown"))
        user.errors[:gender] << "Gender invalid."
      end
    end
  end

  has_many :be_followeds, :class_name => 'Follow', :foreign_key => :followed_id, dependent: :destroy 
  has_many :followers, :through => :be_followeds, :source => :follower, dependent: :destroy 

  has_many :follows, :class_name => 'Follow', :foreign_key => :follower_id, dependent: :destroy 
  has_many :followings, :through => :follows, :source => :followed, dependent: :destroy 

  has_many :home_lines, :through => :followings, :source => :tweets, dependent: :destroy 

  has_many :likes, dependent: :destroy 
  has_many :liked_tweets, :through => :likes, :source => :tweet, dependent: :destroy 

  has_many :tweets, dependent: :destroy 

  enum gender: { unknown: 0, male: 1, female: 2 }

  validates_with UserValidator

  def to_json_obj fields = nil
    obj = {}
    default = ["id", "name", "email", "create_time", "gender", "birthday"]
    fields ||= default
    fields.each do |key|
      obj.store(key, instance_eval("self.#{key}")) if default.include? key
    end
    obj
  end

end