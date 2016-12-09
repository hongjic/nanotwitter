get '/' do
  token = request.cookies["access_token"]
  begin
    user_id = UserUtil::check_token token
    @user = UserUtil::find_user_by_id user_id
    erb :home # for logged_in_users
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound
    @home_line = TweetUtil::get_global_home_line
    erb :index # for not logged_in_users
  end
end

#with authentication 
get '/search' do
  token = request.cookies["access_token"]
  @keyword = params[:keyword]
  begin
    user_id = UserUtil::check_token token
    @user = UserUtil::find_user_by_id user_id
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
    active_user_id = UserUtil::check_token token
    @active_user = UserUtil::find_user_by_id active_user_id
    @target_user = UserUtil::find_user_by_id target_user_id
    @is_following = UserUtil::is_following_user active_user_id, target_user_id
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
    user_id = UserUtil::check_token token
    @user = UserUtil::find_user_by_id user_id
    erb :edit_profile
  rescue JWT::DecodeError
    redirect '/login.html'
  end
end

#with authentication
#no params
get '/js/notification.js' do
  token = request.cookies["access_token"]
  begin
    content_type :js
    @scheme = ENV["RACK_ENV"] == "production" ? "wss://" : "ws://"
    @user_id = UserUtil::check_token token
    @host = ENV["RACK_ENV"] == "production" ? "nanotwitter-notification.herokuapp.com" : "localhost:5000"
    erb :"notification.js"
  rescue JWT::DecodeError
    redirect '/login.html'
  end
end