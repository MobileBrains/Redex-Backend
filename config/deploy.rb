server '45.63.107.207', port: 22, roles: [:web, :app, :db], primary: true

set :user,            'redexadmin'
set :application,     'Redex-Backend'
set :branch,          'master'
set :repo_url,        'git@github.com:MobileBrains/Redex-Backend.git'
set :deploy_to,       "/home/#{fetch(:user)}/apps/#{fetch(:application)}"

#set :scm, :git
set :pty,             true # Default is false
set :stage,           :production
set :use_sudo,        false
set :deploy_via,      :remote_cache
set :keep_releases,   3
set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }


set :rvm_type,        :user
set :rvm_ruby_string, '2.5.1'
set :rails_env,       'production'

# Don't change these unless you know what you're doing




set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
#set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to false when not using ActiveRecord

namespace :deploy do
  desc "Init Setup for the rvm gemsets"
  task :initializer do
    on roles(:app) do
      execute "source ~/.rvm/scripts/rvm && rvm use #{fetch(:rvm_ruby_string)} --default"
    end
  end

  desc "Gems Installation"
  task :bundle_gems do
    on roles(:app) do
      execute "source ~/.rvm/scripts/rvm && cd #{fetch(:deploy_to)}/current && bundle exec bundle install --without development test"
    end
  end

  desc "Start Server"
  task :start do
    on roles(:app) do
      # execute "source ~/.rvm/scripts/rvm && cd #{fetch(:deploy_to)}current && RAILS_ENV='#{fetch(:rails_env)}' rake assets:clean"
      execute "source ~/.rvm/scripts/rvm && cd #{fetch(:deploy_to)}/current && RAILS_ENV='#{fetch(:rails_env)}' bundle exec rake assets:precompile"
      execute "source ~/.rvm/scripts/rvm && cd #{fetch(:deploy_to)}/current && RAILS_ENV='#{fetch(:rails_env)}' bundle exec puma -d -b tcp://127.0.0.1:80 -C ./config/puma.rb"
      execute "source ~/.rvm/scripts/rvm && cd #{fetch(:deploy_to)}/current && RAILS_ENV='#{fetch(:rails_env)}' bundle exec sidekiq -d -C ./config/sidekiq.yml"
      #execute "source ~/.rvm/scripts/rvm && cd #{fetch(:deploy_to)}/current && RAILS_ENV='#{fetch(:rails_env)}' bundle exec foreman start"


    end
  end

  desc "Restart Server"
  task :restart do
    on roles(:app) do
      execute "kill -QUIT `cat /tmp/puma.pid`"
      execute "source ~/.rvm/scripts/rvm && cd #{fetch(:deploy_to)}/current && RAILS_ENV='#{fetch(:rails_env)}' bundle exec puma -d -b tcp://127.0.0.1:80 -C ./config/puma.rb"
    end
  end

  desc "Stop Server"
  task :stop do
    on roles(:app) do
      execute "kill -QUIT `cat /tmp/sidekiq.pid`"
      execute "kill -QUIT `cat /tmp/puma.pid`"
    end
  end
end

before "deploy:start", "deploy:bundle_gems"
before "deploy:bundle_gems", "deploy:initializer"
before "deploy:start", "db:configure"

namespace :figaro do
  desc "SCP transfer figaro configuration to the shared folder"
  task :setup do
    on roles(:app) do
      upload! "config/application.yml", "#{shared_path}/application.yml", via: :scp
    end
  end

  desc "Symlink application.yml to the release path"
  task :symlink do
    on roles(:app) do
      execute "ln -sf #{shared_path}/application.yml #{fetch(:deploy_to)}/current/config/application.yml"
    end
  end
end

after "deploy:started", "figaro:setup"
after "deploy:symlink:release", "figaro:symlink"

namespace :db do
  desc "Create database yaml in shared path"
  task :configure do
    on roles(:app) do

      set :database_username, "redexadmin"
      set :database_password, "c4s420"
      #ask(:database_password, "deploy")

      set :database_name, "redex_db"

      db_config = <<-EOF
        default: &default
          adapter: postgresql
          encoding: unicode
          pool: 5
          username: #{fetch(:database_username)}
          password: #{fetch(:database_password)}
          host: localhost
          port: 5432
        development:
          <<: *default
          database: #{fetch(:database_name)}_development
        production:
          <<: *default
          database: #{fetch(:database_name)}
      EOF

      execute "mkdir -p #{shared_path}/config"

      contents = StringIO.new(db_config)
      upload! contents, "#{shared_path}/config/database.yml"
    end
  end

  desc "Make symlink for database yaml"
  task :link do
    on roles(:app) do
      execute "ln -nfs #{shared_path}/config/database.yml #{fetch(:deploy_to)}/current/config/database.yml"
    end
  end

  desc "Migrate Seed database"
  task :migrate do
    on roles(:app) do
      execute "source ~/.rvm/scripts/rvm && cd #{fetch(:deploy_to)}/current && bundle exec rake RAILS_ENV='#{fetch(:rails_env)}' db:migrate"
      # execute "source ~/.rvm/scripts/rvm && cd #{fetch(:deploy_to)}current && bundle exec rake RAILS_ENV='#{fetch(:rails_env)}' db:seed"
    end
  end

  desc "Backup the database"
  task :backup do
    on roles(:db) do
      #set :database_name, "#{fetch(:application)}_production"
      set :database_name, "redex_db"
      set :timestamp, Time.now.utc.strftime('%Y%m%d%H%M%S')
      execute "mkdir -p #{shared_path}/backups"
      execute "cd #{shared_path}; pg_dump -U #{fetch(:user)} #{fetch(:database_name)} -f backups/#{fetch(:timestamp)}.sql"
      execute "cd #{shared_path}/backups; tar -cvzpf #{fetch(:timestamp)}_backup.tar.gz #{fetch(:timestamp)}.sql"
      execute "cd #{shared_path}/backups; rm -f #{fetch(:timestamp)}.sql"
    end
  end
end

after "db:configure", "db:link"
after "db:link", "db:backup"
after "db:backup", "db:migrate"