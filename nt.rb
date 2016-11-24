require 'sinatra'
require 'active_record'
require 'redis'
require 'bunny'
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
require './models/tweetlist'
require './models/tweet_tag'
require './models/user'
require './models/userlist'

# Load the models
# The requirements above are for the whole application 
# Should be no dependencies
require './lib/algorithms'
require './lib/mqueue/taskproducer'
require './lib/caching/datacache'
require './lib/caching/homeline'
require './lib/caching/timeline'
require './lib/caching/socialgraph'
require './lib/caching/personalinfo'
require './lib/errors'
require './lib/result'
require './lib/userutil'
require './lib/tweetutil'
require './lib/timeutil'
require './lib/likeutil'
require './lib/noteutil'

# Load the code libraries

require 'byebug'


include Api
include Error
include UserUtil
include TweetUtil
include LikeUtil
include TimeUtil
include NoteUtil

# set :raise_errors, false
# set :show_exceptions, false

require './app/application'
require './app/test'

