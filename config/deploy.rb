require 'capistrano/ext/slicehost'

#############################################################
#	Application
#############################################################

set :application, "minimise.it"
set :deploy_to, "/var/www/apps/#{application}"

#############################################################
#	Settings
#############################################################

default_run_options[:pty] = true
set :use_sudo, false

#############################################################
#	Servers
#############################################################

set :user, "ryantownsend"
set :ip, "minimise.vpsnet"
server ip, :app, :web, :gateway
role :db, ip, :primary => true

#############################################################
#	Git
#############################################################

set :scm, "git"
set :repository,  "git@github.com:agincourt/image-resizer.git"

set :ssh_options, { :forward_agent => true }
set :branch, "deploy"

set :deploy_via, :remote_cache
set :git_shallow_clone, 1
set :git_enable_submodules, 1

set :keep_releases, 5

#############################################################
#	Cron Jobs
#############################################################

after "deploy:symlink", "deploy:update_crontab"

namespace :deploy do
  desc "Update the crontab file"
  task :update_crontab, :roles => :app do
    run "cd #{release_path} && whenever --write-crontab #{application}"
  end
end

#############################################################
#	Config
#############################################################

after "deploy:update_code", "deploy:update_database_yml"

namespace :deploy do
  desc "Overwrites the database file on the server with a copy of the shared version"
  task :update_database_yml, :roles => :app do
    run "rm #{release_path}/config/database.yml && cp #{deploy_to}/#{shared_dir}/config/database.yml #{release_path}/config/database.yml && chmod 660 #{release_path}/config/database.yml"
  end
end

#############################################################
#	Passenger
#############################################################

namespace :deploy do
  task :start do
  end
  
  task :restart do
    sudo "touch #{deploy_to}/current/tmp/restart.txt"
  end
end