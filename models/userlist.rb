
class UserList
  # ActiveRecord::Relation
  attr_accessor :users_relation
  attr_accessor :user_list

  def initialize users
    @users_relation = users
  end

  def to_json_obj fields = nil
    # memorization
    return @user_list if @user_list != nil
    
    @user_list = [];
    @users_relation.each do |user_record|
      @user_list.push(user_record.to_json_obj fields)
    end
    @user_list
  end
end