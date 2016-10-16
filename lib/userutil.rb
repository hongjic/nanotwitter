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
    if (userinfo[:password] != userinfo[:password2])
      raise Error::SignUpError, "Your two password inputs are different. Please type again."
    end
    user = User.new
    user.name = userinfo[:username]
    user.email = userinfo[:email]
    user.password = userinfo[:password]
    user.create_time = Time.now().getutc.to_i
    raise Error::SignUpError, user.errors.messages.values[0][0] unless user.save
    user
  end

  # find a user by id
  def find_user_by_id user_id
    user = User.find user_id
  end

end