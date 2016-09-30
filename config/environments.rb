require 'zlib'

#The environment variable DATABASE_URL should be in the following format:
# => postgres://{user}:{password}@{host}:{port}/path
configure :production, :development do
  # db = URI.parse(ENV['DATABASE_FOR_NANOTWITTER'] || 'postgres://localhost/development')
  db_env = ENV["DATABASE_FOR_NANOTWITTER"]
  ActiveRecord::Base.establish_connnection(YAML.load_file(db_env))
	# ActiveRecord::Base.establish_connection(
	# 		:adapter => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
	# 		:host     => db.host,
	# 		:username => db.user,
	# 		:password => db.password,
	# 		:database => db.path[1..-1],
	# 		:encoding => 'utf8'
	# )
end