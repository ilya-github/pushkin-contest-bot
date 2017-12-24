# config valid for current version and patch releases of Capistrano
lock "~> 3.7.0"

set :application, "pushkin-contest-bot"
set :repo_url, "git@github.com:ilya-github/pushkin-contest-bot.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
 set :deploy_to, "/var/www/pushkin-contest-bot"
 set :stage, :production
 set :linked_files, %w{config/database.yml}

 set :linked_dirs, %w{log tmp/pids public/assets tmp/cache tmp/sockets vendor/bundle public/system}

 set :ssh_option, {:forward_agent => true}
 set :pry, false
 set :rvm_ruby_version, '2.4.1@pushkin-contest-bot'

set :sidekiq_config, "#{current_path}/config/sidekiq.yml"
set :sidekiq_processes, 2
set :sidekiq_log, "#{current_path}/log/sidekiq.log"
set :sidekiq_role, :sidekiq

set :puma_preload_app, true
set :puma_init_active_record, true
# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure