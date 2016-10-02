require 'sinatra'
require 'active_record'
require 'byebug'
require './config/environments' #database configuration

require './models/follow'
require './models/like'
require './models/notification'
require './models/tag'
require './models/tweet'
require './models/tweet_tag'
require './models/user'

enable :sessions

get '/' do
  byebug
	erb :index
end