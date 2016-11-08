workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['RAILS_MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  puts "[development environment: #{ENV["RACK_ENV"]}]"
  if ENV['RACK_ENV'] == 'development'
    db = URI.parse(ENV['NT_DATABASE_URL'] || 'postgres://localhost/development')
  elsif ENV['RACK_ENV'] == 'production'
    db = URI.parse(ENV['DATABASE_URL'])
  end
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