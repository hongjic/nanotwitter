require 'sinatra'
require 'active_record'
require 'activerecord-import'
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
require 'faker'

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

get '/test/reset/all' do
  timebefore = Time.now
  UserUtil::destroy_all
  timeafter = Time.now
  @reset_time = timeafter - timebefore
  test_user_params = { :username => "usertest", :email => "testuser@sample.com", :password =>"password", :password2 => "password" }
  begin
    test_user = UserUtil::create_new_user test_user_params
  rescue Error::SignUpError => e
    Api::Result.new(false, e.message).to_json
  end
erb :reset
end



get '/test/users/create' do        #example: /test/users/create?count=100&tweets=5     create u (integer) fake Users using faker with random tweets Defaults to 1

  @user_count = params[:count].to_i
  if @user_count == 0
    @user_count = 1
  end
  @tweet_count = params[:tweets].to_i
  timebefore = Time.now

  user_rows = ["name","email","password","create_time"]

  user_array = UserUtil::random_user_gen @user_count
  users_created = TweetUtil::create_tweets_bulk user_rows, user_array

  ids_created = users_created["ids"]
  @total_users_created = users_created["ids"].count

  tweet_rows = ["user_id","user_name","content","create_time","favors","reply_to_tweet_id"]
  tweet_array = Array.new
  for i in 0..@total_users_created-1 do
    tweet_array.concat(TweetUtil::random_tweet_gen @tweet_count, ids_created[i], user_array[i][0] )
  end
  TweetUtil::create_batch_tweets tweet_rows, tweet_array

  timeafter = Time.now
  @create_time = timeafter - timebefore
  erb :create_users

end


get '/test/status' do

  @number_of_users = UserUtil::user_count
  @number_of_follows = UserUtil::follow_count
  @number_of_tweets = TweetUtil::tweet_count
  @test_user_id = (UserUtil::find_user_by_name "testuser").id

  erb :status

end



get '/test/user/:user/tweets' do   #Example: /test/user/testuser/tweets?tweets=100   #user u generates t(integer) new fake tweets

  @user_name = params[:user]

  @no_of_tweets = params[:tweets].to_i
  if @no_of_tweets == 0
    @no_of_tweets = 1
  end
  
  @user_id = (UserUtil::find_user_by_name @user_name).id

  if @user_id != nil 
        timebefore = Time.now
        tweet_rows = ["user_id","user_name","content","create_time","favors","reply_to_tweet_id"]

        tweet_array = TweetUtil::random_tweet_gen @no_of_tweets, @user_id, @user_name 
        TweetUtil::create_batch_tweets tweet_rows, tweet_array

        timeafter = Time.now
        @create_time = timeafter - timebefore
        erb :tweets_for_user
  else
        @error_message = "User " + @user_name + " does not exist"
        erb :error
  end

end 


get '/test/user/follow' do             #Example: /test/user/follow?count=10  #n (integer) randomly selected users follow ‘n’ (integer) different randomlt seleted users


  @no_of_follows = params[:count].to_i
  if @no_of_follows == 0
    @no_of_follows = 1
  end

  timebefore = Time.now
  list_of_ids = UserUtil::list_of_ids 
  @random_users = list_of_ids.sample(@no_of_follows)
  array_follows = @random_users.permutation(2).to_a

  for i in 0..array_follows.length-1
    array_follows[i] = array_follows[i] + [Time.now]
  end

  follow_rows = ["follower_id","followed_id","create_time"]
  follows_result = UserUtil::follow_bulk follow_rows, array_follows
  @no_of_follows_created = follows_result.ids.count

  timeafter = Time.now
  @create_time = timeafter - timebefore


  erb :random_follows_for_user

end



get '/test/user/:u/follow' do   #Example: /test/user/22/follow?count=10  n (integer) randomly selected users follow user u 

  @user_id = params[:u]
  @no_new_followers = params[:count]


  begin
    user = (UserUtil::find_user_by_id @user_id)

    timebefore = Time.now
    list_of_ids = UserUtil::list_of_ids 

    @random_users = list_of_ids.sample(@no_new_followers.to_i)

    array_follows = Array.new

    for i in 0..@random_users.length-1
      array_follows[i] = [@random_users[i],@user_id,Time.now]
    end

    follow_rows = ["follower_id","followed_id","create_time"]

    follows_result = UserUtil::follow_bulk follow_rows, array_follows
    @no_of_follows_created = follows_result.ids.count

    timeafter = Time.now
    @create_time = timeafter - timebefore

    erb :follows_for_user
  rescue  ActiveRecord::RecordNotFound

    @error_message = "User with ID " + @user_id + " does not exist"
    erb :error
  end
end

