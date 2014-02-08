require 'bundler'
Bundler.require

DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://#{Dir.pwd}/2chez.db")


DataMapper.finalize.auto_upgrade! 	# If I use this with shotgun, it will work fine.
DataMapper.finalize.auto_migrate! # Resets the database

class TwoChez < Sinatra::Application
	enable :sessions
	set :session_secret, 'kilimanjaro'

# Routes

get '/' do
	@title = 'Welcome'
	@css = 'main'
	erb :index
end

get '/admin' do
	@title = 'Dashboard'
	@css = 'admin'
	erb :admin
end

get '/contact' do
	@title = 'Contact Us'
	@css = 'main'
	erb :contact
end

# get "/#{menu}-menu" do
get '/menu' do
	# @title = "#{menu} Menu"
	@title = 'Menu'
	# @css = 'menu'
	@css = 'main'
	erb :menu
end

end