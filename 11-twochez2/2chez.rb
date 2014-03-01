require 'bundler'
Bundler.require(:default, :development)

# DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/2chez')
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")

class User
	include DataMapper::Resource
	include BCrypt

	property :id, 		   	Serial
	property :name, 		Text,		required: true,		unique: true,	key: true
	property :email,		Text,		required: true,		unique: true,	format: :email_address
	property :password, 	BCryptHash, required: true,		length: 8..255
	property :admin,		Boolean,	default: false,		writer: :protected

	def authenticate?(attempted_password)
		self.password == attempted_password ? true : false
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

# User.create(name: 'Todd', email: 'toddhohulin@mchsi.com', password: 'foo', admin: true) ? User.all.length == 0 : false

DataMapper.finalize.auto_upgrade!
# DataMapper.finalize.auto_migrate!

class TwoChez < Sinatra::Application
	use Rack::Session::Cookie, 	secret: 		'kilimanjaro',
								expire_after: 	3600 # session expires after 1 hour

# Routes

before do
	@menu_items = MenuItem.all

	@menus = []
	@menu_items.map { |item| @menus.push(item.menu) unless @menus.include?(item.menu) }
	@menus.sort!

	@categories = []
	@menu_items.map { |item| @categories.push(item.category) unless @categories.include?(item.category) }
	@categories.sort!

	puts '[Params]'
	p params

	headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, OPTIONS'
	headers['Access-Control-Allow-Origin'] = '*'
	headers['Access-Control-Allow-Headers'] = 'accept, authorization, origin'
end

after do
	p @name
end

options '/*' do
    headers['Access-Control-Allow-Origin'] = "*"
    headers['Access-Control-Allow-Methods'] = "GET, POST, PUT, DELETE, OPTIONS"
    headers['Access-Control-Allow-Headers'] ="accept, authorization, origin"
end

#untested
get '/' do
	@title = 'Welcome'
	@admin = false

	erb :index
end

#tested
get '/signup' do
	@title = 'Signup'
	@action = 'sign up'
	@users = User.all
	erb :login
end

#tested
post '/signup' do
	user = User.new
	user.name = params[:name]
	user.email = params[:email]
	user.password = params[:password]
	user.save
	redirect '/login'
end

#tested
get '/login' do
	@title = 'Login'
	@action = 'log in'
	erb :login
end

#tested
post '/login' do
	session[:name] = params[:name]
	session[:password] = params[:password]
	user = User.first(name: session[:name])

	if user.nil?
		redirect '/'
	elsif user.authenticate?(session[:password])
		redirect '/admin'
	else
		redirect '/login'
	end
end

post '/logout' do
	session.destroy
	redirect '/'
end

# untested
get '/admin' do
	@title = 'Dashboard'
	@user = session[:name]
	@admin = true ? @user : false

 	if @user && User.first(name: session[:name]).logged_in?(@user)
 		erb :admin
 	else 
 		redirect '/login'
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

# untested
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