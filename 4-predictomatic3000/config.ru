require './predictomatic'
run Sinatra::Application
set :database, ENV['DATABASE_URL'] || 'postgres://localhost/[YOUR_DATABASE_NAME]'