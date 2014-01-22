# require 'rubygems'
require 'sinatra'
require 'data_mapper'
# require 'shotgun'


# DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/predictomatic.db")
DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://#{Dir.pwd}/predictomatic.db")


class Note  
  include DataMapper::Resource  
  property :id, Serial  
  property :content, Text,      :required => true  
  property :complete, Boolean,  :required => true,  :default => false  
  property :created_at, Date  
  property :updated_at, Date  
  property :player, String,     :required => true  
  property :school, String,     :required => true  
end  


DataMapper.finalize.auto_upgrade!  


get '/' do  
  @notes = Note.all :order => :id.desc  
  @title = 'Welcome'  
  erb :home  
end   

post '/' do  
  n = Note.new  
  n.content = params[:content]
  n.player = params[:player].downcase.split.map { |word| word.capitalize! }.join(' ')
  n.school = params[:school].downcase.split.map { |word| word.capitalize! }.join(' ')
  n.created_at = Time.now  
  n.updated_at = Time.now  
  n.save  
  redirect '/results'  
end

get '/results' do
  @notes = Note.all :order => :created_at.desc
  @title = 'Predictions'
  erb :results
end

get '/:id/player' do  
  @notes = Note.all
  @note = Note.get params[:id]  
  @title = "#{@note.player}"  
  erb :player  
end

get '/:id/user' do  
  @notes = Note.all
  @note = Note.get params[:id]  
  @title = "#{@note.content}"  
  erb :user  
end

get '/:id' do  
  @note = Note.get params[:id]
  @title = "Edit Prediction"
  erb :edit  
end  


put '/:id' do  
  n = Note.get params[:id]  
  n.player = params[:player].downcase.split.map { |word| word.capitalize! }.join(' ')
  n.school = params[:school].downcase.split.map { |word| word.capitalize! }.join(' ')
  n.complete = params[:complete] ? 1 : 0  
  n.updated_at = Time.now  
  n.save  
  redirect '/results'  
end  

get '/:id/delete' do  
  @note = Note.get params[:id]  
  @title = "Confirm deletion of note ##{params[:id]}"  
  erb :delete  
end 

delete '/:id' do  
  n = Note.get params[:id]  
  n.destroy  s
  redirect '/results'  
end  

get '/:id/complete' do  
  n = Note.get params[:id]  
  n.complete = n.complete ? 0 : 1 # flip it  
  n.updated_at = Time.now  
  n.save  
  redirect '/results'  
end  