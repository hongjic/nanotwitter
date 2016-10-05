require 'sinatra'
require 'active_record'
require 'jwt'
require './config/environments' #database configuration
require './config/properties' 
# The requirements above are for framework and basic configurations
require './lib/errors'
require './lib/result'
require './lib/userutil'
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

enable :sessions


get '/' do
    
  erb :index
end

['/login', '/api/v1/user/login'].each do |path|
  post path do
    username = params[:username]
    password = params[:password]
    begin
      token = UserUtil::authenticate username, password
      Api::Result.new(true, {access_token: token}).to_json
    rescue Error::AuthError => e
      Api::Result.new(false, e.message).to_json
    end
  end
end

post '/register' do
  begin
    user = UserUtil::signup params
    token = UserUtil::generate_token user
    Api::Result.new(true, {access_token: token}).to_json
  rescue Error::SignUpError => e
    Api::Result.new(false, e.message).to_json
  end
end

get '/user/:user_id' do

end
