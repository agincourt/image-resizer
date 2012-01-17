unless Capistrano::Configuration.respond_to?(:instance)
  raise StandardError, "Requires Capistrano 2"
end

#############################################################
#	Application
#############################################################

set :application, "minimise"
set :deploy_to, "/data/#{application}"

#############################################################
#	Settings
#############################################################

default_run_options[:pty] = true
set :use_sudo, false

#############################################################
#	Servers
#############################################################

set :user, "deploy"
set :ip, "178.79.133.206"
server ip, :app, :web, :gateway
role :db, ip, :primary => true

#############################################################
#	Git
#############################################################

set :scm, "git"
set :repository,  "git@github.com:agincourt/image-resizer.git"

set :ssh_options, { :forward_agent => true }
set :branch, "master"

set :deploy_via, :remote_cache
set :git_shallow_clone, 1
set :git_enable_submodules, 1

set :keep_releases, 5

#############################################################
#	Config
#############################################################

after "deploy:update_code", "deploy:update_database"

namespace :deploy do
  desc "Overwrites the database file on the server with a copy of the shared version"
  task :update_database, :roles => :app do
    run "rm #{release_path}/config/database.yml && cp #{deploy_to}/#{shared_dir}/config/database.yml #{release_path}/config/database.yml"
  end
  
  task :start do
  end
  
  task :stop do
  end
  
  task :restart do
    sudo "touch #{deploy_to}/current/tmp/restart.txt"
  end
end