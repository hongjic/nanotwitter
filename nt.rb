require 'sinatra'
require 'sinatra/activerecord'
require 'byebug'
require './config/environments' #database configuration

require './models/users'
require './models/tweets'
require './models/followers'
require './models/likes'
require './models/marks'
require './models/tags'
require './models/notifications'

enable :sessions


get '/' do
	erb :index
end