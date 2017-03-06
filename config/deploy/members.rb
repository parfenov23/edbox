set :application, 'members_adonline'
set :user, 'members_adonline'
server '136.243.79.27', user: fetch(:user), roles: %w(web app db)
set :rails_env, 'production'
set :branch, :members

set :deploy_to, "/home/#{ fetch :user }/htdocs"
set :unicorn_pid, "#{ fetch :deploy_to }/shared/pids/unicorn.pid"
set :unicorn_config_path, "#{ fetch :deploy_to }/current/config/unicorn/members.rb"

task :copy_latters_shared, roles: :app do
  run "cp -a #{release_path}/app/views/home_mailers #{shared_path}"
end

task :shared_copy_latters, roles: :app do
  run "cp -a #{shared_path} #{release_path}/app/views/home_mailers"
end

namespace :deploy do
  after :copy_latters_shared
  before :shared_cope_latters
end