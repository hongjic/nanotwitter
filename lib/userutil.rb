module UserUtil

  class UserList
    # ActiveRecord::Relation
    attr_accessor :users_relation

    def initialize users
      @users_relation = users
    end

    def to_json_obj fields = nil
      list = [];
      @users_relation.each do |user_record|
        list.push(user_record.to_json_obj fields)
      end
      list
    end
  end


  # Authenticate the username and password 
  # If match, return access_token
  def authenticate username, password
    user = User.find_by name: username
    if user == nil
      raise Error::AuthError, "User not found."
    elsif password != user.password
      raise Error::AuthError, "Password is not correct."
    else
      generate_token user
    end
  end

  # check whether the token is valid and not expired yet.
  def check_token token 
    decoded_token = JWT.decode token, $TOKEN_SECRET, true, { algorithm: $TOKEN_HASH }
    User.find(decoded_token[0]["user_id"])
  end

  # generate access_token by Hashing algorithm
  def generate_token user
    expire_time = Time.now.to_i + 4 * 3600
    token_data = {user_id: user.id, exp: expire_time}
    JWT.encode token_data, $TOKEN_SECRET, $TOKEN_HASH
  end

  # sign up new user
  def create_new_user userinfo
    if (userinfo["password"] != userinfo["password2"])
      raise Error::SignUpError, "Your two password inputs are different. Please type again."
    end
    user = User.new
    user.name = userinfo["username"]
    user.email = userinfo["email"]
    user.password = userinfo["password"]
    user.create_time = Time.now().getutc.to_i
    raise Error::SignUpError, user.errors.messages.values[0][0] unless user.save
    user
  end

  # update user info (except for password)
  def update_user_info user, new_info
    new_info.keys.each do |key|
      user[key] = new_info[key]
    end
    raise Error::UserUpdateError, user.errors.messages.values[0][0] unless user.save
    user
  end

  # find a user by id
  def find_user_by_id user_id
    user = User.find user_id
  end

  # find a user by name
  # name is unique
  def find_user_by_name user_name
    user = User.where(name: user_name)[0]
  end

  # find a user by keyword (name contains keyword)
  def find_users_by_keyword keyword, fields
    users = UserList.new User.where("name LIKE ?", '%' + keyword + '%')
    users.to_json_obj fields
  end

  # check whether the active user is following
  def is_following_user follower_user, following_user
    !Follow.where("follower_id = ? and followed_id = ? ", follower_user.id, following_user.id).empty?
  end

  def add_follow_relation follower_id, followed_id
    t = Time.now().to_i
    follow = Follow.new 
    follow.follower_id = follower_id
    follow.followed_id = followed_id
    follow.create_time = t
    follow.save
  end

  def delete_follow_relation follower_id, followed_id
    follows = Follow.where("follower_id = ? and followed_id = ?", follower_id, followed_id)
    follows.each do |follow|
      follow.destroy
    end
  end


  module Test

    #create a batch of users, columns is an array with the names of fields to be written
    #users is an array of arrays, each containing the user data
    def create_tweets_bulk columns,users
      User.import columns, users
    end

    def destroy_all
      User.destroy_all
    end

    def list_of_ids
      User.ids
    end

    def follow_bulk follow_rows, array_follows
      Follow.import follow_rows, array_follows
    end

    def random_user_gen user_count
      user_array = Array.new
      for i in 0..user_count-1 do
        user_name = (rand(100).to_s + Faker::Internet.user_name)[1..20]
        password = Faker::Internet.password(8)
        user_params = [ user_name, Faker::Internet.email, password, Time.now ]
        user_array[i]=user_params
      end
      user_array
    end

    def user_count
      User.count
    end

    def follow_count
      Follow.count
    end

  end

end