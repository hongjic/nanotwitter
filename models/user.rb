class User < ActiveRecord::Base

  class UserValidator < ActiveModel::Validator
    def validate user 
      if user.password == nil || user.password.length < 6 || user.password.length > 20
        user.errors[:password] << "Password should be longer than 6 and shorter than 20."
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

  validates :name, presence: {message: "Please provide your user name."}, uniqueness: {message: "User name already exists."}, length: {in: 2..20, message: "name length: 2 to 20"} 
  validates :email, presence: {message: "Please provide your email."}, uniqueness: {message: "Email has already been used."}
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