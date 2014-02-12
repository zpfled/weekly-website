require 'bundler'
Bundler.require

DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://#{Dir.pwd}/2chez.db")

class Editor
	include DataMapper::Resource
	include BCrypt

	property :id, 		   	Serial
	property :username, 	Text,		required: true
	property :password, 	BCryptHash, required: true

	def authenticate?(attempted_password)
    	if self.password == attempted_password
      		true
    	else
      		false
    	end
  	end
end

class MenuItem
	include DataMapper::Resource

	property :id,			Serial
	property :menu,			String, 	required: true
	property :name,			String, 	required: true
	property :description,	Text, 		required: true
	property :price,		Integer, 	required: true
	property :added_on,		Date
	property :updated_on,	Date
end


DataMapper.finalize.auto_upgrade!
# DataMapper.finalize.auto_migrate!

class TwoChez < Sinatra::Application
	enable :sessions
	set :session_secret, 'kilimanjaro'

# Routes

get '/' do
	@title = 'Welcome'
	@css = 'main'
	erb :index
end

get '/login' do
	@title = 'Login'
	@users = User.all
	erb :login
end

post '/login' do
	session[:username] = params[:username]
	session[:password] = params[:password]
	
	user = User.first(username: session[:username])

	if user.nil?
		redirect '/login'
	elsif user.authenticate?(session[:password])
		redirect '/admin'
	else
		redirect '/'
	end
end

get '/admin' do
	item = MenuItem.new
	item.menu = "dinner"
	item.name = "chicken pesto sandwich"
	item.description = "yummy sandwich with chicken and pesto and bread and a pickle and cheese and mushrooms."
	item.price = "9"
	item.save
	@title = 'Dashboard'
	@css = 'admin'
	@menu_items = MenuItem.all
	erb :admin, layout: false
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