# A sample Guardfile
# More info at https://github.com/guard/guard#readme
#require 'active_support/core_ext'

guard 'livereload' do
  watch(%r{views/.+\.(erb|haml|slim)$})
  watch(%r{app/helpers/.+\.rb})
  watch(%r{public/.+\.(css|js|html)})
  watch(%r{config/locales/.+\.yml})
  # Rails Assets Pipeline
  watch(%r{(app|vendor)(/assets/\w+/(.+\.(css|js|html|png|jpg))).*}) { |m| "/assets/#{m[3]}" }
end

guard 'spork' do
  watch('Gemfile')
  watch('Gemfile.lock')
  watch('spec/spec_helper.rb') { :rspec }
  watch('spec/support/')
  watch('myapp.rb')           # for example, reload spork when myapp.rb is changed
end

guard 'rspec', :wait => 60, :all_after_pass => false, :cli => '--drb' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^spec/factories/.+\.rb$})
  watch('spec/spec_helper.rb')                { "spec" }
  watch(%r{^spec/support/(.+)\.rb$})          { "spec" }
  watch('myapp.rb')                           { "spec" }
end