
get '/' do
  token = request.cookies["access_token"]
  begin
    @user = UserUtil::check_token token
    erb :home # for logged_in_users
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound
    count = Tweet.count
    @home_line = Tweet.offset(count-50 > 0 ? count-50 : 0).limit(50)
    erb :index # for not logged_in_users
  end
end


#with authentication 
get '/search' do
  token = request.cookies["access_token"]
  @keyword = params[:keyword]
  begin
    @user = UserUtil::check_token token
    erb :search #only display a framework and use ajax to implement data-driven
  rescue JWT::DecodeError
    redirect '/login.html'
  end
end

# show PROFILE_VIEW/TWEETS
# different layouts depends on whether the active user is the owner
get '/users/:id' do
  token = request.cookies["access_token"]
  target_user_id = params[:id].to_i
  begin
    @active_user = UserUtil::check_token token
    @target_user = UserUtil::find_user_by_id target_user_id
    @is_following = UserUtil::is_following_user @active_user, @target_user
    erb :profile 
    # if the target_user==active_user, show edit_profile, otherwise, show Follow/Following
  rescue JWT::DecodeError
    redirect '/login.html'
  rescue ActiveRecord::RecordNotFound
    redirect "/404.html"
  end
end

# with authentication
# edit profile
get '/edit_profile' do
  token = request.cookies["access_token"]
  begin
    @user = UserUtil::check_token token
    erb :edit_profile
  rescue JWT::DecodeError
    redirect '/login.html'
  end
end

#no authentication
post '/api/v1/users/login' do
  @json = JSON.parse request.body.read
  username = @json["username"]
  password = @json["password"]
  begin
    token = UserUtil::authenticate username, password
    Api::Result.new(true, {access_token: token}).to_json
  rescue Error::AuthError => e
    Api::Result.new(false, e.message).to_json
  end
end

#no authentication
post '/api/v1/users' do
  @json = JSON.parse request.body.read
  begin
    user = UserUtil::create_new_user @json
    token = UserUtil::generate_token user
    Api::Result.new(true, {access_token: token}).to_json
  rescue Error::SignUpError => e
    Api::Result.new(false, e.message).to_json
  end
end

#with authentication
put '/api/v1/users/selfinfo' do
  token = request.cookies["access_token"]
  @json = JSON.parse request.body.read
  begin
    user = UserUtil::check_token token
    user = UserUtil::update_user_info user, @json
    Api::Result.new(true, {user: user.to_json_obj}).to_json
  rescue JWT::DecodeError
    401
  rescue Error::UserUpdateError => e
    Api::Result.new(false, e.message).to_json
  end
end

#with authentication
get '/api/v1/users/:id/followings' do
  token = request.cookies["access_token"]
  target_user_id = params[:id].to_i
  begin
    active_user = UserUtil::check_token token
    user_list = UserUtil::get_following_user_list target_user_id
    Api::Result.new(true, {followings: user_list}).to_json
  rescue JWT::DecodeError
    401
  end
end

#with authentication
get '/api/v1/users/:id/followers' do
  token = request.cookies["access_token"]
  target_user_id = params[:id].to_i
  begin
    active_user = UserUtil::check_token token
    user_list = UserUtil::get_follower_user_list target_user_id
    Api::Result.new(true, {followers: user_list}).to_json
  rescue JWT::DecodeError
    401
  end
end

#with authentication
post '/api/v1/tweets' do
  @json = JSON.parse request.body.read
  token = request.cookies["access_token"]
  content = @json["content"]
  reply_to_tweet_id = @json["reply_to_tweet_id"]
  begin
    @user = UserUtil::check_token token
    tweet = TweetUtil::create_new_tweet @user, content, reply_to_tweet_id
    Api::Result.new(true, {tweet: tweet.to_json_obj}).to_json
  rescue Error::TweetError => e
    Api::Result.new(false, e.message).to_json
  rescue JWT::DecodeError
    401
  end
end

#with authentication
get '/api/v1/homeline' do
  token = request.cookies["access_token"]
  begin
    @active_user = UserUtil::check_token token
    home_line = TweetUtil::get_home_line @active_user
    Api::Result.new(true, {home_line: home_line}).to_json
  rescue JWT::DecodeError
    401
  end
end

#with authentication
get '/api/v1/users/:user_id/tweets' do
  token = request.cookies["access_token"]
  begin
    @active_user = UserUtil::check_token token
    user_id = params[:user_id].to_i
    time_line = TweetUtil::get_time_line user_id
    Api::Result.new(true, {time_line: time_line}).to_json
  rescue JWT::DecodeError
    401
  end
end

#with authentication
get '/api/v1/users/:user_id' do
  token = request.cookies["access_token"]
  # fields' format: ["name", "email", "gender"] a list.
  fields = params[:fields]
  begin
    @active_user = UserUtil::check_token token
    user_id = params[:user_id].to_i
    user = UserUtil::find_user_by_id user_id
    Api::Result.new(true, {user: user.to_json_obj(fields)}).to_json
  rescue JWT::DecodeError
    401
  end
end

#with authentication
get '/api/v1/search/users' do
  token = request.cookies["access_token"]
  begin
    @user = UserUtil::check_token token
    keyword = params[:keyword]
    fields = params[:fields]
    users = UserUtil::find_users_by_keyword keyword, fields
    Api::Result.new(true, {users: users}).to_json
  rescue JWT::DecodeError
    401
  end
end

#with authentication
get '/api/v1/search/tweets' do
  token = request.cookies["access_token"]
  begin
    @user = UserUtil::check_token token
    keyword = params[:keyword]
    fields = params[:fields]
    tweets = TweetUtil::find_tweets_by_keyword keyword, fields
    Api::Result.new(true, {tweets: tweets}).to_json
  rescue JWT::DecodeError
    401
  end
end

#with authentication
post '/api/v1/follows' do
  token = request.cookies["access_token"]
  begin
    @user = UserUtil::check_token token
    json = JSON.parse request.body.read
    following_id = json["following_id"]
    UserUtil::add_follow_relation @user.id, following_id
    user = UserUtil::find_user_by_id following_id
    Api::Result.new(true, {new_following: user.to_json_obj}).to_json
  rescue JWT::DecodeError
    401
  end
end

#with authentication
delete '/api/v1/follows' do
  token = request.cookies["access_token"]
  begin
    @user = UserUtil::check_token token
    json = JSON.parse request.body.read
    following_id = json["following_id"]
    UserUtil::delete_follow_relation @user.id, following_id
    Api::Result.new(true, {}).to_json
  rescue JWT::DecodeError
    401
  end
end

error Sinatra::NotFound do
  redirect '/404.html'
end