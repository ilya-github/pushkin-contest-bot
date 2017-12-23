# config valid for current version and patch releases of Capistrano
lock "~> 3.5"

set :application, "pushkin"
set :repo_url, "git@github.com:ilya-github/pushkin-contest-bot.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
 set :deploy_to, "/var/www/pushkin"

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
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"




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