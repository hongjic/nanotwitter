
threads 5, 5
workers 2
preload_app!

on_worker_boot do
  puts "[development environment: #{ENV["RACK_ENV"]}]"
  db = URI.parse(ENV['NT_DATABASE_URL'] || 'postgres://localhost/development')
  ActiveRecord::Base.establish_connection(
    :adapter => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
    :host => db.host,
    :username => db.user,
    :password => db.password,
    :database => db.path[1..-1],
    :encoding => 'utf8',
    :pool => 10
    )
end

before_fork do
  puts "disconnect database connection."
  ActiveRecord::Base.connection_pool.disconnect!
end