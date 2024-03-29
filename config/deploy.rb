require 'bundler/capistrano'
require 'airbrake/capistrano'

set :rvm_type, :system
require "rvm/capistrano"

set :bundle_flags, '--deployment --quiet --binstubs'

ssh_options[:forward_agent] = true
default_run_options[:pty] = true

set :user, 'deployer'
set :application, 'exams'
set :repository, "git@github.com:pepijn/#{application}.git"
set :keep_releases, 3
set :use_sudo, false
set :deploy_to, "/var/apps/#{application}"
set :deploy_via, :copy

server "server.plict.nl", :app, :db, :web, primary: true

after "deploy:update_code", "deploy:permissions"
after "deploy", "deploy:cleanup"

namespace :deploy do
  task :permissions do
    run "chmod 766 #{shared_path}/{log/*,pids}"
  end

  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

namespace :db do
  desc "Import remote database to local"
  task :pull do
    `powify server restart && spring rake db:drop && spring rake db:create`
    remote_path = "#{current_path}/tmp/db.sql"
    run "pg_dump --no-owner --no-privileges --username #{application} #{application} > #{remote_path} && gzip -f #{remote_path}"
    download "#{remote_path}.gz", "tmp/db.sql.gz"
    run_locally "gunzip -f tmp/db.sql.gz && psql #{application}_development < tmp/db.sql && spring rake db:migrate && spring rake db:seed"
  end
end

task :log do
  run "tail -fn 100 #{current_path}/log/*.log"
end

