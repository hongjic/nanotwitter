# These are all APIs.
# To make code easy to understand and be heavily reused,
# code in the API block only shows the general logic

#no authentication
post '/api/v1/users/login' do
  @json = JSON.parse request.body.read
  username = @json["username"]
  password = @json["password"]
  begin
    user = UserUtil::authenticate username, password
    token = UserUtil::generate_token user.id
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
    token = UserUtil::generate_token user.id
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
    user_id = UserUtil::check_token token
    user_info = UserUtil::update_user_info user_id, @json
    Api::Result.new(true, {user: user_info}).to_json
  rescue JWT::DecodeError
    401
  rescue Error::UserUpdateError => e
    Api::Result.new(false, e.message).to_json
  end
end

#with authentication
put '/api/v1/users/selfid' do
  token = request.cookies["access_token"]
  begin
    user_id = UserUtil::check_token token
    Api::Result.new(true, {user: user_id}).to_json
  rescue JWT::DecodeError
    401
  rescue Error::UserUpdateError => e
    Api::Result.new(false, e.message).to_json
  end
end

#with authentication
get '/api/v1/users/:id/followings' do
  t1 = Time.now().to_f
  token = request.cookies["access_token"]
  target_user_id = params[:id].to_i
  begin
    UserUtil::check_token token
    user_list = UserUtil::get_following_user_list target_user_id
    t2 = Time.now().to_f
    puts "[Performance] Path='/api/v1/users/#{target_user_id}/followings' time=#{t2 - t1}"
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
    UserUtil::check_token token
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
    user = UserUtil::find_user_by_id(UserUtil::check_token token)
    tweet = TweetUtil::create_new_tweet user, content, reply_to_tweet_id
    if tweet["reply_to_tweet_id"] != nil 
      target_user_id = TweetUtil::find_tweet_by_id(tweet["reply_to_tweet_id"])["user_id"]
      NoteUtil::create_reply_note tweet["id"], user["name"], target_user_id
    end
    Api::Result.new(true, {tweet: tweet}).to_json
  rescue Error::TweetError => e
    Api::Result.new(false, e.message).to_json
  rescue JWT::DecodeError
    401
  end
end

#with authentication
get '/api/v1/homeline' do
  t1 = Time.now().to_f
  token = request.cookies["access_token"]
  id_max = params[:id_max].to_i
  number = params[:number].to_i
  begin
    active_user_id = UserUtil::check_token token
    home_line = TweetUtil::get_home_line active_user_id, id_max, number
    home_line = LikeUtil::mark_favor_on_tweets home_line, active_user_id
    t2 = Time.now().to_f
    puts "[Performance] Path='/api/v1/homeline' time=#{t2 - t1}"
    Api::Result.new(true, {home_line: home_line}).to_json
  rescue JWT::DecodeError
    401
  end
end

#with authentication
get '/api/v1/users/:user_id/tweets' do
  token = request.cookies["access_token"]
  begin
    active_user_id = UserUtil::check_token token
    user_id = params[:user_id].to_i
    time_line = TweetUtil::get_time_line user_id
    time_line = LikeUtil::mark_favor_on_tweets time_line, active_user_id
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
    UserUtil::check_token token
    user_id = params[:user_id].to_i
    user = UserUtil::find_user_by_id user_id, fields
    Api::Result.new(true, {user: user}).to_json
  rescue JWT::DecodeError
    401
  end
end

#with authentication
get '/api/v1/search/users' do
  token = request.cookies["access_token"]
  begin
    UserUtil::check_token token
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
    active_user_id = UserUtil::check_token token
    keyword = params[:keyword]
    fields = params[:fields]
    tweets = TweetUtil::find_tweets_by_keyword keyword, fields
    tweets = LikeUtil::mark_favor_on_tweets tweets, active_user_id
    Api::Result.new(true, {tweets: tweets}).to_json
  rescue JWT::DecodeError
    401
  end
end

#with authentication
post '/api/v1/follows' do
  token = request.cookies["access_token"]
  begin
    user_id = UserUtil::check_token token
    user_name = UserUtil::find_user_by_id(user_id)["name"]
    json = JSON.parse request.body.read
    following_id = json["following_id"]
    UserUtil::add_follow_relation user_id, following_id
    NoteUtil::create_follow_note user_id, user_name, following_id
    user = UserUtil::find_user_by_id following_id
    Api::Result.new(true, {new_following: user}).to_json
  rescue JWT::DecodeError
    401
  end
end

#with authentication
delete '/api/v1/follows' do
  token = request.cookies["access_token"]
  begin
    user_id = UserUtil::check_token token
    json = JSON.parse request.body.read
    following_id = json["following_id"]
    UserUtil::delete_follow_relation user_id, following_id
    Api::Result.new(true, "Follow relationship deleted.").to_json
  rescue JWT::DecodeError
    401
  end
end

#with authentication
post '/api/v1/likes' do
  token = request.cookies["access_token"]
  begin
    user_id = UserUtil::check_token token
    json = JSON.parse request.body.read
    tweet_id = json["tweet_id"]
    favors = LikeUtil::add_user_like user_id, tweet_id
    return Api::Result.new(false, "Add like fails.").to_json if !favors # in ruby, !0 == false
    Api::Result.new(true, {favors: favors}).to_json
  rescue JWT::DecodeError
    401
  end
end

#with authentication
delete '/api/v1/likes' do
  token = request.cookies["access_token"]
  begin
    user_id = UserUtil::check_token token
    json = JSON.parse request.body.read
    tweet_id = json["tweet_id"]
    favors = LikeUtil::delete_user_like user_id, tweet_id
    return Api::Result.new(false, "Delete like fails.").to_json if !favors # in ruby, !0 == false
    Api::Result.new(true, {favors: favors}).to_json
  rescue JWT::DecodeError
    401
  end
end

#with authentication
#no params
get '/api/v1/users/:id/likes' do
  token = request.cookies["access_token"]
  begin
    active_user_id = UserUtil::check_token token
    user_id = params[:id]
    tweets_liked = LikeUtil::get_favor_tweets user_id
    tweets_liked = LikeUtil::mark_favor_on_tweets tweets_liked, active_user_id
    Api::Result.new(true, {tweets: tweets_liked}).to_json
  rescue JWT::DecodeError
    401
  end
end

#with authentication
#no params
get '/api/v1/notifications' do
  token = request.cookies["access_token"]
  begin
    active_user_id = UserUtil::check_token token
    notifications = NoteUtil::get_notifications_by_userid active_user_id
    Api::Result.new(true, {notifications: notifications}).to_json
  rescue JWT::DecodeError
    401
  end
end

#no authentication
get '/loaderio-fa27893a9bb7f9bfda3e6a412384eaea/' do
  "loaderio-fa27893a9bb7f9bfda3e6a412384eaea"
end

# no authentication 
# params: user_id
get '/test2' do
  id_max = 0
  number = 15
  active_user_id = params[:user_id].to_i
  home_line = TweetUtil::get_home_line active_user_id, id_max, number
  home_line = LikeUtil::mark_favor_on_tweets home_line, active_user_id
  Api::Result.new(true, {home_line: home_line}).to_json
end

get '/test3' do
  id_max = 0
  number = 15
  active_user_id = params[:user_id].to_i
  randomtweet = params[:randomtweet].to_i
  if (rand(100) < randomtweet)
    user = UserUtil::find_user_by_id(active_user_id)
    TweetUtil::create_new_tweet user, "random tweet", nil
  end
  home_line = TweetUtil::get_home_line active_user_id, id_max, number
  home_line = LikeUtil::mark_favor_on_tweets home_line, active_user_id
  Api::Result.new(true, {home_line: home_line}).to_json
end

error Sinatra::NotFound do
  redirect '/404.html'
end
