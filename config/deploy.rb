# Capistrano Config file for a University of Sydney branded Ruby on Rails application.

# Please do a find and replace - find "CHANGEAPPNAME" replace with your new
# app name, which should be the same as your subversion repository name.

# we now use monit
#require 'mongrel_cluster/recipes'

# see Advanced Rails Recipes 52 & 53
# depends on ruby gem capistrano-ext
set :scm, "git"
set :stages, %w(development uat staging production)
set :default_stage, 'development'

# set :default_environment, {
#   'PATH' => "/opt/ruby-enterprise-1.8.7-2010.02/bin:$PATH",
#   'http_proxy' => "http://www-cache.usyd.edu.au:8080"
# }

require 'capistrano/ext/multistage'
require 'bundler/capistrano'
require 'capistrano_colors'

$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                  # Load RVM's capistrano plugin.

# require 'net/ssh/proxy/http'

set(:rails_env) { "#{stage}" }

set :application, 'webdb'
#set :repository, "ssh://roses@agile-svn.ucc.usyd.edu.au/var/git/#{application}.git"
set :repository, "http://github.com/abradner/webdb.git"
set :user, 'rails'
set :use_sudo, true

#USYD SPECIFIC STUFF
#set :use_sudo, false
#set :repository, "ssh://roses@agile-svn.ucc.usyd.edu.au/var/git/#{application}.git"
#set :user, 'roses'
#set :http_proxy, "http://web-cache.usyd.edu.au:8080"

# In order for sudo to work, we now need this:
default_run_options[:pty] = true

set :deploy_to, "/var/www/apps/#{application}"
# set :deploy_via, :export # Not actually sure if 'export' can be used with git
#set :deploy_via, :remote_cache # Not required, but makes deployments faster.
set :deploy_via, :export

# the proc {} allows lazy evaluation of the stage variable
#set(:mongrel_conf) { "#{deploy_to}/current/config/mongrel_cluster_#{stage}.yml" }

# stops the error we get calling 'app' command which doesn't exist, see:
set :runner, nil

# Bundler flags can be explicitly set here.  Default is below
# set :bundle_gemfile,      "Gemfile"
# set :bundle_dir,          fetch(:shared_path)+"/bundle"
# set :bundle_flags,       "--deployment --quiet"
# set :bundle_without,      [:development, :test]


#task :development do
#  set :ruby_path, "/usr/local/bin"
#  set :rake, "export PATH=#{ruby_path}:$PATH; bundle exec rake"
#  set :bundle_cmd, "export PATH=#{ruby_path}:$PATH; export http_proxy=#{http_proxy}; bundle" # Default is "bundle"
#  role :app, "agile-sdlc-dev-06.ucc.usyd.edu.au"
#  role :web, "agile-sdlc-dev-06.ucc.usyd.edu.au"
#  role :db,  "agile-sdlc-dev-06.ucc.usyd.edu.au", :primary => true
#  set :stage, :development
#  set :branch, "development"
#  set :bundle_without, [:test]
#end

task :uat do

  set :rvm_ruby_string, 'ree-1.8.7-2011.03@webdb'        # Or whatever env you want it to run in.
  set :rvm_type, :user  # Copy the exact line. I really mean :user here

  role :web, 'gsw1-archer-uat.intersect.org.au' 
  role :app, 'gsw1-archer-uat.intersect.org.au'
  role :db, 'gsw1-archer-uat.intersect.org.au', :primary => true

  #set :ruby_path, "/opt/ruby-enterprise-1.8.7-2011.03/bin"
  #set :ruby_path, "/home/rails/.rvm/rubies/ree-1.8.7-2011.03/bin"
  #set :rake, "export PATH=#{ruby_path}:$PATH; bundle exec rake"
  #set :bundle_cmd, "export PATH=#{ruby_path}:$PATH; bundle" # Default is "bundle"
  #set :bundle_cmd, "export PATH=#{ruby_path}:$PATH; export http_proxy=#{http_proxy}; bundle" # Default is "bundle"
  set :stage, :uat
  set :branch, "master"
  set :bundle_flags, ""
  set :bundle_without, [:test]
end


#TODO
task :production do
  set :ruby_path, "/usr/local/bin"
  set :rake, "export PATH=#{ruby_path}:$PATH; bundle exec rake"
  set :bundle_cmd, "export PATH=#{ruby_path}:$PATH; export http_proxy=#{http_proxy}; bundle" # Default is "bundle"
  set :domain, '' #TODO
  role :web, domain
  role :app, domain
  role :db, domain, :primary => true
  set :stage, :production
  set :branch, :production
  set :deploy_to, "/var/www/apps/#{application}"
  set :bundle_flags, ""
  set :bundle_without, [:test]
end

namespace :deploy do
  desc "DO NOT RUN in production!!! Will create permissions and map roles to permissions for SUPERADMIN and ADMIN"
  task :aclgen do
    rake = fetch(:rake, 'rake')
    run "cd #{current_release}; #{rake} aclgen:create"
  end
    
  desc "Starts delayed job"  
  task :start_delayed_job do
    run "cd #{current_release}; RAILS_ENV=#{rails_env} script/delayed_job start"
  end
    
  desc "Stops delayed job"
  task :stop_delayed_job do 
    run "cd #{current_release}; RAILS_ENV=#{rails_env} script/delayed_job stop"
  end
    
  desc "Restarts delayed job"
  task :restart_delayed_job do
    run "cd #{current_release}; RAILS_ENV=#{rails_env} script/delayed_job restart"
  end

  desc "Load the schema into the database (WARNING: destructive!)"
  task :schema_load, :roles => :db do
    rake = fetch(:rake, 'rake')
     run "cd #{current_release}; #{rake} RAILS_ENV=#{stage} db:schema:load"
   end

 desc "DO NOT RUN in production!!! Populate tables from Database Migrations / Fixtures"
  task :populate do
    rake = fetch(:rake, 'rake')
    run "cd #{current_release}; #{rake} RAILS_ENV=#{stage} db:populate"
  end

  desc "DO NOT RUN in production!!! This will delete live data! Run only in test environment."
  task :reset do
    rake = fetch(:rake, 'rake')
    run "cd #{current_release}; #{rake} RAILS_ENV=#{stage} db:migrate:reset db:mongoid:drop"
  end
  
  desc "DO NOT RUN in production!!! This will delete live data! Run only in test environment."
  task :refresh_mongoid do
    rake = fetch(:rake, 'rake')
    run "cd #{current_release}; #{rake} RAILS_ENV=#{stage} db:mongoid:drop"
  end

  desc "TO BE RUN DURING INITIAL DEPLOY ONLY!!!! Populates initial data."
  task :seed do
    rake = fetch(:rake, 'rake')
    run "cd #{current_release}; #{rake} RAILS_ENV=#{stage} db:seed"
  end

  desc "Grants execute permissions on ruby scripts."
  task :update_permissions do
    run "cd #{current_release}; chmod -R ug+x script" # uncomment for backgroundrb; chmod a+x config/backgroundrb_*.sh"
  end
  
  desc "restart passenger"
  task :restart, :roles => :app, :except => { :no_release => true } do
    rake = fetch(:rake, 'rake')
    run "touch /var/www/apps/#{application}/current/tmp/restart.txt"
  end

  desc "Full redepoyment, it runs deploy:update, deploy:refresh_db, and deploy:restart"
  task :full_redeploy do
      update
      refresh_db
      restart
  end

  # Helper task which re-creates the database
  desc "DO NOT RUN in production!!! This will delete live data! Run only in test environment."
  task :refresh_db, :roles => :db do
    require 'colorize'
    puts "This step (deploy:refresh_db) will erase all data and start from scratch.\nYou probably don't want to do it. Are you sure?' [NO/yes]".colorize(:red)
    input = STDIN.gets.chomp
    if input.match(/^yes/)
      schema_load
      refresh_mongoid
      seed
      populate
    else
      puts "Skipping database nuke"
    end
  end


end

desc "Tails the log on the remote server"
task :tail_log, :roles => :app do
  stream "tail -f #{shared_path}/log/#{stage}.log"
end

# Install after hooks
after "deploy:update_code", "deploy:update_permissions", "deploy:restart_delayed_job"
