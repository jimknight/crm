source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.10'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.21'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
#gem 'spring',        group: :development

group :development, :test do
  gem 'pry'
  gem 'rspec-rails', '~> 3.0.0'
  gem 'launchy'
  # gem "capybara-webkit"
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'faker'
  gem 'database_cleaner'
end

gem 'annotate', '~> 2.6.5'

gem 'bootstrap-sass', '~> 3.4.1'
gem 'autoprefixer-rails'

# https://github.com/plataformatec/devise/issues/4630
# gem 'devise', '~>4.3.0'
gem 'devise', git: 'https://github.com/plataformatec/devise' #, ref: '88e9a85'
gem 'devise-bootstrap-views', '~> 0.0.11'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
group :development do
  gem 'capistrano',  '~> 3.1'
  gem 'capistrano3-nginx', '~> 2.0'
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'capistrano-rbenv', '~> 2.0', require: false
  gem "letter_opener"
end

# Use debugger
# gem 'debugger', group: [:development, :test]

gem 'figaro'
gem 'simple_form'
gem 'momentjs-rails'#, '~> 2.9',  :github => 'derekprior/momentjs-rails'
# gem 'datetimepicker-rails', github: 'zpaulovics/datetimepicker-rails', branch: 'master', submodules: true
gem 'business_time'
gem 'carrierwave'
gem 'roo', '~> 2.0.0'
gem 'area'
# http://stackoverflow.com/questions/21179956/no-such-file-or-directorypublic-assets-manifest
gem 'sprockets', '2.12.5'
gem 'pg_search'
gem 'jquery-turbolinks'
gem 'whenever', :require => false
gem 'email_validator'
gem 'activeadmin', '~> 1.0.0.pre2'
gem 'rails4-autocomplete'

# jQuery UI dependency.
gem 'jquery-ui-rails'

gem 'kaminari'
gem 'exception_notification'
gem 'factory_girl_rails'
gem 'chronic'

# https://stackoverflow.com/questions/51980353/autoprefixer-doesn-t-support-node-v0-10-37-error
gem 'mini_racer'

# Security issue CVE-2018-16468
gem "loofah", ">= 2.2.3"

gem "puma", ">= 4.3.3"

# Security issue CVE-2018-16471
gem "rack", ">= 1.6.11"

# Security issue CVE-2018-16476
# bundle update activejob
