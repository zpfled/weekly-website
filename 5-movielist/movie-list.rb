# Libraries

# require 'sinatra'
# require 'shotgun'
# require 'rack/flash'
# require 'warden'

# require 'data_mapper'
# require 'dm-postgres-adapter'
# require 'bcrypt'

require 'bundler'
Bundler.require

# Database Models

DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://#{Dir.pwd}/movie-list.db")

class User
	include DataMapper::Resource
	include BCrypt

	property :id, 		   	Serial
	property :username, 	Text,		required: true
	property :password, 	BCryptHash, required: true

	has n, :movies

	def authenticate?(attempted_password)
    	if self.password == attempted_password
      		true
    	else
      		false
    	end
  	end
end

class Movie  
  include DataMapper::Resource
  property :id, 			Serial
  property :title, 			Text,      	required: true
  property :added_on, 		Date
  property :watched, 		Boolean, 	required: true, 	default: false

  belongs_to :user


end 

DataMapper.finalize.auto_upgrade! 	# If I use this with shotgun, it will work fine.
# DataMapper.finalize.auto_migrate! # If I use this with shotgun, every time I add a user it will be deleted instantly.

# App Setup

class MovieListApp < Sinatra::Application
	enable :sessions
	set :session_secret, 'silverscreen'

# Routes

get '/' do
	@title = 'Home'
	erb :home
end

post '/' do
 	@users = User.all
 	@user_exists = false

 	@users.each { |user| @user_exists = true if params[:username] == user.username }

 	if @user_exists
 		redirect '/login'
 	else
 		new_user = User.new
 		new_user.username = params[:username]
 		new_user.password = params[:password]
 		new_user.save
 		
 		session[:username] = params[:username]
 		redirect "/#{new_user.id}"
 	end
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
		redirect '/'
	elsif user.authenticate?(session[:password])
		redirect "/#{user.id}"
	else
		redirect '/logout'
	end
end

get '/logout' do
	session.clear
	redirect '/login'
end

get '/:id' do
 	@current_user_name = session[:username]
 	@title = "#{@current_user_name}"

 	if @current_user_name
		@current_user = User.first(username: session[:username])
		if @current_user_name != @current_user.username
			redirect '/'
		else
		@movies = @current_user.movies.all :order => :added_on.desc
		erb :list
		end
	else
		redirect '/logout'
	end
end

post '/:id' do
	@current_user = User.get params[:id]
	m = @current_user.movies.new
	m.title = params[:title].downcase.split.map { |word| word.capitalize! }.join(' ')
	m.added_on = Time.now
	m.save

	redirect "/#{@current_user.id}"
end

get '*/:id/watched' do
	user = User.first(username: session[:username])
	movie = user.movies.get params[:id]

	movie.watched = true
	movie.added_on = Time.now
	movie.save

	redirect "/#{user.id}"
end

get '*/:id/delete' do
	user = User.first(username: session[:username])
	movie = user.movies.get params[:id]

	if movie
		movie.destroy
	else
		redirect '/'
	end

	redirect "/#{user.id}"
end


end # of app