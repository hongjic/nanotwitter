require 'sinatra'
require 'active_record'
require 'jwt'
require './config/environments' #database configuration
require './config/properties' 
# The requirements above are for framework and basic configurations
require './lib/errors'
require './lib/result'
require './lib/userutil'
require './lib/tweetutil'
require './lib/timeutil'
# The requirements above are for the whole application 
# Should be no dependencies
require './models/follow'
require './models/like'
require './models/notification'
require './models/tag'
require './models/tweet'
require './models/tweet_tag'
require './models/user'
require 'byebug'

include Api
include Error
include UserUtil
include TweetUtil
include TimeUtil

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

# show PROFILE_VIEW/TWEETS
# different layouts depends on whether the active user is the owner
get '/user/:id' do
  token = request.cookies["access_token"]
  begin
    @active_user = UserUtil::check_token token

  rescue JWT::DecodeError
    401
  end
end

#no authentication
post '/api/v1/users/login' do
  username = params[:username]
  password = params[:password]
  begin
    token = UserUtil::authenticate username, password
    Api::Result.new(true, {access_token: token}).to_json
  rescue Error::AuthError => e
    Api::Result.new(false, e.message).to_json
  end
end

#no authentication
post '/api/v1/users' do
  begin
    user = UserUtil::create_new_user params
    token = UserUtil::generate_token user
    Api::Result.new(true, {access_token: token}).to_json
  rescue Error::SignUpError => e
    Api::Result.new(false, e.message).to_json
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
get '/api/v1/user/:user_id' do
  token = request.cookies["access_token"]
  # fields' format: ["name", "email", "gender"] a list.
  fields = params[:fields]
  begin
    @active_user = UserUtil::check_token token
    user_id = params[:user_id]
    user = UserUtil::find_user_by_id user_id
    Api::Result.new(true, {user: user.to_json_obj(fields)}).to_json
  rescue JWT::DecodeError
    401
  end
end