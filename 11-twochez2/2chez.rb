require 'bundler'
Bundler.require(:default, :development)

DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/2chez')
# DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")

class User
	include DataMapper::Resource
	include BCrypt

	property :id, 		   	Serial
	property :name, 		Text,		required: true,		unique: true,	key: true
	property :email,		Text,		required: true,		unique: true,	format: :email_address
	property :password, 	BCryptHash, required: true,		length: 8..255
	property :admin,		Boolean,	default: false,		writer: :protected

	def authenticate?(attempted_password)
		self.password != attempted_password ? true : false
	end

	def logged_in?(user)
		self.name == user ? true : false
	end

end

class MenuItem
	include DataMapper::Resource

	property :id,			Serial
	property :menu,			String, 	required: true # e.g. Lunch, Dinner, Wine
	property :category,		String,		required: true # e.g. Starters, Chicken, Cabernet Sauvignon, Interesting Whites
	property :name,			String, 	required: true # e.g. Calimari, Snoqualmie
	property :description,	Text, 		required: true
	property :price,		Integer, 	required: true
end

DataMapper.finalize.auto_upgrade!
# DataMapper.finalize.auto_migrate!

class TwoChez < Sinatra::Application
	enable :sessions
		set :session_secret, 'persenukedipsekjonukpunon',
		expire_after: 	3600 # session expires after 1 hour

# Routes

before do
	@users = User.all
	@menu_items = MenuItem.all

	@menus = []
	@menu_items.map { |item| @menus.push(item.menu) unless @menus.include?(item.menu) }
	@menus.sort!

	@categories = []
	@menu_items.map { |item| @categories.push(item.category) unless @categories.include?(item.category) }
	@categories.sort!
end

after do
	p @name
end

options '/*' do
    headers['Access-Control-Allow-Origin'] = "*"
    headers['Access-Control-Allow-Methods'] = "GET, POST, PUT, DELETE, OPTIONS"
    headers['Access-Control-Allow-Headers'] ="accept, authorization, origin"
end

get '/' do
	@title = 'Welcome'
	@admin = false

	erb :index
end

get '/signup' do
	@message = ' '
	@title = 'Signup'
	@action = 'sign up'
	erb :login
end

post '/signup' do
	@user_exists = false

 	@users.each { |user| @user_exists = true if params[:name] == user.name }

 	if @user_exists
 		redirect '/'
 	else
		user = User.new
		user.name = params[:name]
		user.email = params[:email]
		user.password = params[:password]
		user.save
		redirect '/login'
	end
end

get '/login' do
	@message = "#{User.last.name}, #{User.last.password}"
	@title = 'Login'
	@action = 'log in'
	erb :login
end

post '/login' do
	session[:name] = params[:name]
	@password = session[:password] = params[:password]
	
	user = User.first(name: session[:name])

	if user.nil?
		redirect '/'
	elsif user.authenticate?(@password)
		redirect '/admin'
	else
		redirect "/#{user.password}"
	end
end

post '/logout' do
	session.destroy
	redirect '/'
end

get '/admin' do
	@title = 'Dashboard'
	@user = session[:name]
	@admin = true ? @user : false

 	if @user && User.first(name: session[:name]).logged_in?(@user)
 		erb :admin
 	else 
 		redirect '/login'
 		# erb :admin
 	end
end

get '/menu' do
	@user = session[:name]
	@admin = true ? @user : false
	
 	if @user && User.first(name: session[:name]).logged_in?(@user)
 		erb :menu, layout: false
 	else
 		redirect '/'
 	end
end

post '/menu' do
	item = MenuItem.new
	item.name = params[:name]
	item.description = params[:description]
	item.price = params[:price]
	item.menu = params[:menu].split('-').join(' ')
	cat = "#{params[:menu]}_category".to_sym
	item.category = params[cat]
	item.save

	redirect '/menu'
end

get '/:id/raise' do
	item = MenuItem.get params[:id]
	@price = item.price = item.price + 1
	item.save

	if request.xhr?
		halt 200, "#{@price}"
	else
		redirect '/'
	end
end

get '/:id/reduce' do
	item = MenuItem.get params[:id]
	@price = item.price = item.price - 1
	item.save

	if request.xhr?
		halt 200, "#{@price}"
	else
		redirect '/'
	end
end

get '/:id/delete' do
	item = MenuItem.get params[:id]
	item.destroy
	@name = item.name

	if request.xhr?
		halt 200, "#{@name}"
	else
		redirect '/'
	end
end

end