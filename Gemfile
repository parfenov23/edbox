source 'https://rubygems.org'

gem 'rails', '4.1.8'
# gem 'mysql2'
gem 'pg', '0.18.3'


# gem 'jquery-rails'
gem 'jbuilder', '~> 2.0'
gem 'mechanize'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'actionpack-page_caching'

gem 'unicorn'
gem 'faraday'
gem 'bootstrap-material-design', '~> 0.1.7'
gem 'faraday_middleware'
gem 'multi_xml'
gem 'russian'
gem 'bcrypt'
# gem 'turbolinks'
gem 'thin', '~> 1.5.0'
gem 'babosa'
gem 'activerecord-session_store'

#===================== webinar
gem 'bigbluebutton_rails', github: 'mconf/bigbluebutton_rails', branch: 'master'
#=====================

# Frontend
gem 'uglifier'
gem 'sass-rails'
gem 'autoprefixer-rails'
gem 'mini_magick', '4.2.7'
gem 'slim', '~> 2.0.0'
gem 'without-rails'
gem 'coffee-rails'
gem 'carrierwave'
gem 'streamio-ffmpeg'
gem 'eventmachine', '1.0.4'
gem 'rails-i18n'

#Filter Model
# gem 'will_filter'
# gem 'kaminari'

gem 'less-rails', '~> 2.7.0'
gem 'therubyracer', :platforms => :ruby

#===================== websocket
gem 'websocket-rails', github: 'moaa/websocket-rails', branch: 'sync_fixes'
gem 'hiredis'
gem 'redis', :require => ["redis", "redis/connection/hiredis"]
gem 'redis-namespace'
gem 'em-synchrony'
gem 'redis-rails'
gem 'redis-rack-cache' #
gem 'rack-fiber_pool'
gem 'spawnling', '~>2.1'
#=====================
#======= cron
gem 'whenever', :require => false
gem 'rufus-scheduler'
#======

group :production do
  gem 'skylight'
end

group :development do
  gem 'rails-erd'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'mailcatcher', '0.6.1'
  # gem 'sqlite3'
  gem 'sqlite3'
  gem 'sqlite3_ar_regexp', '~> 2.1'
  gem 'pry'
  gem 'capistrano', '~> 3.0', require: false
  gem 'capistrano-rails', '~> 1.1', require: false
  gem 'capistrano-bundler', '~> 1.1', require: false
  gem 'capistrano-rvm', '~> 0.1', require: false
  gem 'capistrano3-unicorn'
  gem 'slackistrano', require: false
  gem 'net-ssh', '~> 2.7.0'
  gem 'guard-livereload', '~> 2.4', require: false
  # gem 'spring'
end
