module UserUtil

  # Authenticate the username and password 
  # If match, return access_token
  def authenticate username, password
    user = User.find_by name: username
    if user == nil
      raise Error::AuthError, "User not found."
    elsif password != user.password
      raise Error::AuthError, "Password is not correct."
    else
      user
    end
  end

  # check whether the token is valid and not expired yet.
  # return a user_id
  def check_token token 
    decoded_token = JWT.decode token, $TOKEN_SECRET, true, { algorithm: $TOKEN_HASH }
    decoded_token[0]["user_id"]
  end

  # generate access_token by Hashing algorithm
  def generate_token user_id
    expire_time = Time.now.to_i + 4 * 3600
    token_data = {user_id: user_id, exp: expire_time}
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
    user.create_time = Time.now().to_i
    raise Error::SignUpError, user.errors.messages.values[0][0] unless user.save
    user
  end

  # update user info (except for password)
  def update_user_info user_id, new_info
    personalinfo = PersonalInfo.new user_id
    info = personalinfo.update_personal_info new_info
  end

  # find a user by id
  def find_user_by_id user_id, fields = nil
    personalinfo = PersonalInfo.new user_id
    user = personalinfo.get_personal_info
    return user if fields == nil
    user_fields = {}
    default = ["id", "name", "email", "create_time", "gender", "birthday"]
    fields.each { |key| user_fields.store(key, user[key]) if default.include? key }
    user_fields
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
  def is_following_user user_id, following_id
    social_graph = SocialGraph.new user_id
    social_graph.is_following? following_id
  end

  def add_follow_relation user_id, following_id
    social_graph = SocialGraph.new user_id
    social_graph.add_follow following_id
    homeline = HomeLine.new user_id
    homeline.add_follow following_id
  end

  def delete_follow_relation user_id, following_id
    social_graph = SocialGraph.new user_id
    social_graph.delete_follow following_id
    homeline = HomeLine.new user_id
    homeline.delete_follow following_id
  end

  # return a list of json objects
  def get_following_user_list user_id
    social_graph = SocialGraph.new user_id
    userid_list = social_graph.get_following_list
    users = UserList.new User.where(id: userid_list)
    users.to_json_obj
  end

  # return a list of json objects
  def get_follower_user_list user_id
    social_graph = SocialGraph.new user_id
    userid_list = social_graph.get_follower_list
    users = UserList.new User.where(id: userid_list)
    users.to_json_obj
  end


  module Test

    #create a batch of users, columns is an array with the names of fields to be written
    #users is an array of arrays, each containing the user data
    def create_batch_users columns,users
      User.import columns, users
    end

    def destroy_all
      #Tweet.in_batches.destroy_all
      #Follow.in_batches.destroy_all
      #User.in_batches.destroy_all 
      ActiveRecord::Base.connection.execute("TRUNCATE notifications, tags, tweets, users")
      ActiveRecord::Base.connection.execute("TRUNCATE tweets,notifications,tags")
      ActiveRecord::Base.connection.execute("TRUNCATE follows")

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
        user_params = [ user_name, Faker::Internet.email, password, Time.now.to_i ]
        user_array[i]=user_params
      end
      user_array
    end

    def random_user_param_gen user_names
      user_array = Array.new
      for i in 0..user_names.length-1 do
        user_id = user_names[i][0]
        user_name = user_names[i][1]
        password = Faker::Internet.password(8)
        user_params = [user_id, user_name, user_name+'@'+Faker::Internet.email.partition('@').last, password, Time.now.to_i ]
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