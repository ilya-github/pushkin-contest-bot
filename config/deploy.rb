# config valid for current version and patch releases of Capistrano
lock "~> 3.10.1"

set :application, "pushkin-contest-bot"
set :repo_url, "git@github.com:ilya-github/pushkin-contest-bot.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/www/pushkin-contest-bot"
 set :rvm_ruby_version, '2.4.1@pushkin-contest-bot'
# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
 append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
 set :default_env, { path: "/opt/ruby/bin:$PATH" }

set :sidekiq_config, "#{current_path}/config/sidekiq.yml"
set :sidekiq_processes, 2
set :sidekiq_log, "#{current_path}/log/sidekiq.log"
set :sidekiq_role, :sidekiq

set :puma_preload_app, true
set :puma_init_active_record, true
set :puma_bind,       "unix:///var/www/pushkin-contest-bot/shared/tmp/sockets/puma.sock"
set :puma_state,      "var/www/pushkin-contest-bot/shared/tmp/pids/puma.state"
set :puma_pid,        "var/www/pushkin-contest-bot/shared/tmp/pids/puma.pid"



set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to false when not using 


namespace :puma do
desc 'Create Directories for Puma Pids and Socket'
task :make_dirs do
on roles(:app) do
execute "mkdir #{shared_path}/tmp/sockets -p"
execute "mkdir #{shared_path}/tmp/pids -p"
end
end
before :start, :make_dirs
end
namespace :deploy do
desc "Make sure local git is in sync with remote."
task :check_revision do
on roles(:app) do
unless `git rev-parse HEAD` == `git rev-parse origin/master`
puts "WARNING: HEAD is not the same as origin/master"
puts "Run `git push` to sync changes."
exit
end
end
end
desc 'Initial Deploy'
task :initial do
on roles(:app) do
before 'deploy:restart', 'puma:start'
invoke 'deploy'
end
end
desc 'Restart application'
task :restart do
on roles(:app), in: :sequence, wait: 5 do
invoke 'puma:restart'
end
end
before :starting,     :check_revision
after  :finishing,    :compile_assets
after  :finishing,    :cleanup
after  :finishing,    :restart
end
# ps aux | grep puma    # Get puma pid
# kill -s SIGUSR2 pid   # Restart puma
# kill -s SIGTERM pid   # Stop puma


# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
