require 'minitest/autorun'
require 'minitest/spec'
require 'rack/test'
require 'webrat'
require 'webrat/core/matchers'
require_relative Dir.pwd+'/nt.rb'
require Dir.pwd+'/nt.rb'
require "webrat/core/locators/locator"
require "byebug"
require 'json'


Webrat.configure do |config|
  config.mode = :rack
end

class TestnT < Minitest::Test
	include Rack::Test::Methods
	include Webrat::Methods
	include Webrat::Matchers

	def setup
		if (UserUtil::find_user_by_name "Bonnie") == nil then
			get '/test/reset/standard'
		end
		if (UserUtil::find_user_by_name "testuser") == nil then
			get '/test/users/create/testuser'
		end
		@test_user_id = (UserUtil::find_user_by_name "testuser").id
	end

	def app
		Sinatra::Application
	end

	def test_testuser
		refute_equal "Testuser should exist (ie, id=!nil)",@test_user_id
	end

	def test_welcome_nT
		get '/'
		assert last_response.ok?
		assert last_response.body.include?('course project for cosi105b'),"Should display course project info"
		assert last_response.body.include?('Log in'),"Should include login"
	end

	def test_login_display
		get '/login.html'
		assert last_response.ok?
		assert last_response.body.include?('Enter username'),"Should include username"
		assert last_response.body.include?('Sign in'),"Should include sign in"
	end

	def test_login
		params  = {'username' => 'testuser', 'password' => 'password'}.to_json
		post('/api/v1/users/login',params) 
		response = JSON.parse(last_response.body)
		assert_equal("success",response["resultCode"])
		refute_empty(response["resultMsg"]["access_token"])
	end

	def test_follows
		username = "Bonnie"
		password = (UserUtil::find_user_by_name username).password

		params  = {'username' => username, 'password' => password}.to_json
		post('/api/v1/users/login',params) 
		response_login = JSON.parse(last_response.body)
		token = response_login["resultMsg"]["access_token"]

		set_cookie 'access_token='+token.to_s
		put('/api/v1/users/selfid')
		response_id = JSON.parse(last_response.body)
		user_id = response_id["resultMsg"]["user"]

		get '/api/v1/users/'+user_id.to_s+'/followings'
		response_followings = JSON.parse(last_response.body)
		no_followings = response_followings["resultMsg"]["followings"].count

		get '/api/v1/users/'+user_id.to_s+'/followers'
		response_followers = JSON.parse(last_response.body)
		no_followers = response_followers["resultMsg"]["followers"].count

		assert_equal("success",response_id["resultCode"])
		assert_equal("success",response_followings["resultCode"])
		assert_equal("success",response_followers["resultCode"])
		refute_nil(response_id["resultMsg"]["user"])
		assert_operator no_followers, :>=,3
		assert_operator no_followings, :>=,2
	end

	def test_timeline
		username = "Dan"
		password = (UserUtil::find_user_by_name username).password

		params  = {'username' => username, 'password' => password}.to_json
		post('/api/v1/users/login',params) 
		response_login = JSON.parse(last_response.body)
		token = response_login["resultMsg"]["access_token"]

		set_cookie 'access_token='+token.to_s
		get "/api/v1/homeline?id_max=0&number=50"
		response_timeline = JSON.parse(last_response.body)
		no_tweets = response_timeline["resultMsg"]["home_line"].count
		assert_equal("success",response_timeline["resultCode"])
		assert_operator no_tweets, :>=,10
	end

	def test_post_tweet
		username = "testuser"
		password = "password"

		params  = {'username' => username, 'password' => password}.to_json
		post('/api/v1/users/login',params) 
		response_login = JSON.parse(last_response.body)
		token = response_login["resultMsg"]["access_token"]

		set_cookie 'access_token='+token.to_s
		put('/api/v1/users/selfid')
		response_id = JSON.parse(last_response.body)
		user_id = response_id["resultMsg"]["user"]

		content = "This is a test tweet - Minitest set of tests"
		params  = {'content' => content, 'reply_to_tweet_id' => nil}.to_json
		set_cookie 'access_token='+token.to_s
		post("/api/v1/tweets",params)
		response_post_tweet = JSON.parse(last_response.body)
		assert_equal("success",response_post_tweet["resultCode"])
		assert_equal(user_id,response_post_tweet["resultMsg"]["tweet"]["user_id"])
	end
end