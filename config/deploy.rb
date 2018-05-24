server '149.28.104.34', port: 22, roles: [:web, :app, :db], primary: true


# TODO: change to your app name
set :application, "Redex-Backend"

set :stages, %w(production staging)
set :default_stage, "staging"

require 'capistrano/ext/multistage'
require 'bundler/capistrano'

default_run_options[:pty] = true

# TODO: change to your user name and group name on the server
set :user, -> { "redexadmin" }
set :group, -> { "sudo" }

set :use_sudo, true
set :scm, :git

# TODO: specify your repository and where you want to deploy to
set :repository, "git@github.com:MobileBrains/Redex-Backend.git"
set :deploy_to, -> { "/home/#{fetch(:user)}/apps/#{fetch(:application)}" }

set :deploy_via, :remote_cache
set :deploy_env, -> { "#{stage}" }
set :rails_env, -> { "#{stage}" }

set :default_environment, {
  'rvmsudo_secure_path' => 1
}

# TODO: change to your ruby version and gemset name
set :rvm_ruby_string, -> { "2.5.1@redex" }

before 'deploy', 'rvm:install_rvm'
before 'deploy', 'rvm:install_ruby'

require "rvm/capistrano"

namespace :rvm do
  desc 'Trust rvmrc file'
  task :trust_rvmrc do
    run "rvm rvmrc trust #{current_release}"
    run "rvm rvmrc trust #{release_path}"
  end
end

after "deploy:update_code", "rvm:trust_rvmrc"

namespace :deploy do
  desc "Symlink shared configs and folders on each release."
  task :symlink_shared do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
end

after 'deploy:update_code', 'deploy:symlink_shared'

# TODO: get rid of #{sudo} whoami hack if your sudo works without password. You need this hack if you've been asked for one.
namespace :foreman do
  desc "Export the Procfile to Ubuntu's upstart scripts"
  task :export, :roles => :app do
    run "#{sudo} whoami && cd #{current_path} && rvmsudo bundle exec foreman export upstart /etc/init -a #{application} -f ./Procfile.#{stage} -u #{user} -l #{release_path}/log"
  end

  desc "Start the application services"
  task :start, :roles => :app do
    run "#{sudo} whoami && rvmsudo start #{application}"
  end

  desc "Stop the application services"
  task :stop, :roles => :app do
    run "#{sudo} whoami && rvmsudo stop #{application}"
  end

  desc "Restart the application services"
  task :restart, :roles => :app do
    run "#{sudo} whoami && sudo start #{application} || sudo restart #{application}"
  end
end

after "deploy:update", "foreman:export"
after "deploy:update", "foreman:restart"

load 'deploy/assets'

