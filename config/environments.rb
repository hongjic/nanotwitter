require 'sinatra'
require 'active_record'
require 'yaml'
#The environment variable DATABASE_URL should be in the following format:
# => postgres://{user}:{password}@{host}:{port}/path
configure :production, :development do
  #db_env = ENV["DATABASE_FOR_NANOTWITTER"]
  db_env = "development_sam"
  puts "[development environment: #{db_env}]"
  database = YAML.load_file("config/database.yml")
  ActiveRecord::Base.establish_connection(database[db_env])
end