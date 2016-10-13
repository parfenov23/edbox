set :application, 'adonline'
set :user, 'adonline'
server '136.243.79.27', user: fetch(:user), roles: %w(web app db)
set :rails_env, 'production'
set :branch, :release

set :deploy_to, "/home/#{ fetch :user }/htdocs"
set :unicorn_pid, "#{ fetch :deploy_to}/shared/pids/unicorn.pid"
set :unicorn_config_path, "#{ fetch :deploy_to }/current/config/unicorn/release.rb"