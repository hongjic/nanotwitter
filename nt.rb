require 'sinatra'
require 'active_record'
require 'activerecord-import'
require 'jwt'
require 'faker'
require './config/environments' #database configuration
require './config/properties' 

# The requirements above are for framework and basic configurations

require './models/follow'
require './models/like'
require './models/notification'
require './models/tag'
require './models/tweet'
require './models/tweet_tag'
require './models/user'

# Load the models
# The requirements above are for the whole application 
# Should be no dependencies

require './lib/errors'
require './lib/result'
require './lib/socialgraph'
require './lib/userutil'
require './lib/tweetutil'
require './lib/timeutil'

# Load the code libraries

require 'byebug'


include Api
include Error
include UserUtil
include TweetUtil
include TimeUtil

# set :raise_errors, false
# set :show_exceptions, false

require './app/application'
require './app/test'

