source 'http://rubygems.org'

gem 'rails', '3.1.1'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '~> 3.1.1'
  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier'
  gem 'ios-checkboxes'
end

group :test do
  # Pretty printed test output
  gem 'turn', :require => false

  # Testing specific applications
#  gem 'escape_utils'
  gem 'email_spec'
end
    
group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'shoulda'

  # cucumber gems
  gem 'cucumber'
  gem 'cucumber-rails'
  gem 'capybara'
  gem 'database_cleaner'
  #gem 'spork'
  gem 'launchy'    # So you can do Then show me the page
  gem 'faker'
  gem 'metrical'
  gem 'ruby-debug' # for 1.8.x
#  gem 'ruby-debug19', :require => 'ruby-debug' # for 1.9.x

end

group :development do
  gem 'rails3-generators'
  gem 'cheat'
  #gem 'mongrel'
end

#gem 'pg'
gem 'bson_ext'
gem 'mysql'
#gem 'sqlite3'
gem 'mongoid'

gem 'jquery-rails'
gem 'devise'
#gem 'updated_by', :git => 'git://github.com/lucasrenan/updated-by.git' # created/updated by hooks for each record wih devise
gem 'cancan'

gem 'capistrano-ext'
gem 'capistrano'
gem 'capistrano_colors'

gem 'fastercsv'
gem 'delayed_job'

gem 'colorize' #Colourisable console output - http://colorize.rubyforge.org

gem 'haml'
gem "haml-rails"
#gem 'hpricot'
gem 'decent_exposure'

gem 'system_timer'

#gem 'squeel'

#Extra Features
#gem 'json'
#gem 'nested_form'
#gem 'rails3-jquery-autocomplete'

gem 'tenacity', :git => 'https://github.com/jwood/tenacity.git'# associations between different ORMs

#Use git until rails 3.1 stuff is pulled into ryanb's gem
gem 'nested_form', :git => 'https://github.com/jweslley/nested_form.git'

# File handling
#gem 'paperclip'
gem 'carrierwave' # file upload
gem 'carrierwave-mongoid', :require => "carrierwave/mongoid"
gem 'remotipart' #ajax upload
#gem 'mini_magick' # Image processing
gem 'rack-gridfs'


gem 'settingslogic' #Global constant management