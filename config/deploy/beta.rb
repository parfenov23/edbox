set :application, 'beta_adonline'
set :user, 'beta_adonline'
server '136.243.79.27', user: fetch(:user), roles: %w(web app db)
set :rails_env, 'production'
set :branch, :master

set :deploy_to, "/home/#{ fetch :user }/htdocs"
set :unicorn_pid, "#{ fetch :deploy_to }/shared/pids/unicorn.pid"
set :unicorn_config_path, "#{ fetch :deploy_to }/current/config/unicorn/beta.rb"