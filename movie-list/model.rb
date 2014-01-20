#Libraries

require 'data_mapper'
require 'dm-postgres-adapter'
require 'bcrypt'

# Database Models

DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://#{Dir.pwd}/movie-list.db")

class User
	include DataMapper::Resource
	include BCrypt

	property :id, 		   	Serial
	property :username, 	Text,		required: true
	property :password, 	BCryptHash, required: true

	has n, :movies

	def authenticate(attempted_password)
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

DataMapper.finalize
DataMapper.auto_migrate!