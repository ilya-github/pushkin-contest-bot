# config valid for current version and patch releases of Capistrano
lock "~> 3.10.1"

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

