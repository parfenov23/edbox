set :application, 'edbox'
set :user, 'edbox'
server '148.251.233.232', user: fetch(:user), roles: %w(web app db)
set :rails_env, 'production'
set :branch, :naukacity

set :deploy_to, "/home/#{ fetch :user }/htdocs"
set :unicorn_pid, "#{ fetch :deploy_to}/shared/pids/unicorn.pid"
set :unicorn_config_path, "#{ fetch :deploy_to }/current/config/unicorn/release.rb"