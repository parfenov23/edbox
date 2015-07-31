# config valid only for current version of Capistrano
lock '3.4.0'

set :rvm_type, '/usr/local/rvm'
set :rvm_custom_path, '/usr/local/rvm'
set :rvm_ruby_version, '2.1.0'

set :application, 'edbox'
set :repo_url, 'git@bitbucket.org:masshtab/edbox.git'
set :user, 'edbox'
set :deploy_to, "/home/#{ fetch :user }/htdocs"

set :linked_files, fetch(:linked_files, []).push('config/database.yml',
                                                 'config/secrets.yml')

set :linked_dirs, fetch(:linked_dirs, []).push('log',
                                               'tmp/pids',
                                               'tmp/cache',
                                               'tmp/sockets',
                                               'vendor/bundle',
                                               'public/system')

set :pty, false
set :keep_releases, 3
set :whenever_roles, [:app]

namespace :deploy do
  after 'deploy:publishing', 'deploy:restart'
  task :restart do
    invoke 'unicorn:legacy_restart'
  end

  task :start do
    invoke 'unicorn:start'
  end

  task :stop do
    invoke 'unicorn:stop'
  end
end
