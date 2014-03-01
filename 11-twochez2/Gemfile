source "https://rubygems.org"
ruby "2.0.0"
gem 'sinatra'
gem 'data_mapper'
gem 'bcrypt-ruby',			require: 'bcrypt'
gem 'multi_json', '1.8.4'

group :development, :test do
	gem 'shotgun'
	gem 'rspec'
	gem 'guard'

	gem 'guard-rspec'

	gem 'guard-spork', '1.4.2'
	gem 'spork', '0.9.2'
	gem 'growl'
end

group :test do
	gem 'rack-test'
	gem 'capybara'
end

group :development do
	gem 'guard-livereload', require: false
	gem 'sqlite3'
	gem 'dm-sqlite-adapter'
end

group :production do
	gem 'pg'
	gem 'dm-postgres-adapter'
end