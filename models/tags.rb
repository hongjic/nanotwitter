class Tag < ActiveRecord::Base
  has_many :marks
  has_many :tweets, through: :marks
end