# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'crm'
set :user, "sgadeploy"
set :repo_url, 'https://github.com/jimknight/crm.git'
set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

# setup rbenv.
set :rbenv_type, :system
set :rbenv_path, '/home/sgadeploy/.rbenv'
set :rbenv_ruby, '1.9.3-p286'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app_name
#set :deploy_to, "/home/deployer/apps/crm"
set :deploy_to, "/home/sgadeploy/crm"

# which config files should be copied by deploy:setup_config
# see documentation in lib/capistrano/tasks/setup_config.cap
# for details of operations
set(:config_files, %w(
  nginx.conf
  database.example.yml
  unicorn.rb
  unicorn_init.sh
))

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml')

# Default value for linked_dirs is []
#set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

# which config files should be made executable after copying
# by deploy:setup_config
set(:executable_config_files, %w(
  unicorn_init.sh
))

# files which need to be symlinked to other parts of the
# filesystem. For example nginx virtualhosts, log rotation
# init scripts etc.
set(:symlinks, [
  {
    source: "nginx.conf",
    link: "/etc/nginx/sites-enabled/#{fetch(:application)}"
  },
  {
    source: "unicorn_init.sh",
    link: "/etc/init.d/unicorn_#{fetch(:application)}"
  }
])

namespace :deploy do

  task :setup_config do
    on roles(:app) do

      # make the config dir
      execute :mkdir, "-p #{shared_path}/config"
      # make the uploads dir
      execute :mkdir, "-p #{shared_path}/uploads"
      # invoke 'nginx:site:add'
      file = File.open('config/database.example.yml')
      upload! file, "#{shared_path}/config/database.yml"
      execute "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
      upload! "config/nginx.conf", "/etc/nginx/sites-enabled/#{fetch(:application)}", via: :scp
      execute :mkdir, "-p #{current_path}/tmp/pids"

    # template "unicorn.rb.erb", unicorn_config
    # template "unicorn_init.erb", "/tmp/unicorn_init"
    # run "chmod +x /tmp/unicorn_init"
    # run "#{sudo} mv /tmp/unicorn_init /etc/init.d/unicorn_#{application}"


      upload! "config/unicorn.rb", "#{current_path}/config/unicorn.rb"
      # execute "update-rc.d -f unicorn_#{:application} defaults"
      full_app_name = fetch(:full_app_name)

      # config files to be uploaded to shared/config, see the
      # definition of smart_template for details of operation.
      # Essentially looks for #{filename}.erb in deploy/#{full_app_name}/
      # and if it isn't there, falls back to deploy/#{shared}. Generally
      # everything should be in deploy/shared with params which differ
      # set in the stage files
      # config_files = fetch(:config_files)
      # config_files.each do |file|
      #   smart_template file
      # end

      # which of the above files should be marked as executable
      executable_files = fetch(:executable_config_files)
      executable_files.each do |file|
        execute :chmod, "+x #{current_path}/config/#{file}"
      end

      # symlink stuff which should be... symlinked
      symlinks = fetch(:symlinks)
      symlinks.each do |symlink|
        # requires passwordless sudo on server
        sudo "ln -nfs #{current_path}/config/#{symlink[:source]} #{symlink[:link]}"
      end

      # uploads
      execute "ln -nfs #{shared_path}/uploads  #{release_path}/public/uploads"

      # Setup logs
      execute "rm -rf #{release_path}/log"
      execute "ln -s  #{shared_path}/log #{release_path}"

      # Whenever
      set :whenever_roles,        ->{ :db }
      set :whenever_command,      ->{ [:bundle, :exec, :whenever] }
      set :whenever_command_environment_variables, ->{ {} }
      set :whenever_identifier,   ->{ fetch :application }
      set :whenever_environment,  ->{ fetch :rails_env, fetch(:stage, "production") }
      set :whenever_variables,    ->{ "environment=#{fetch :whenever_environment}" }
      set :whenever_update_flags, ->{ "--update-crontab #{fetch :whenever_identifier} --set #{fetch :whenever_variables}" }
      set :whenever_clear_flags,  ->{ "--clear-crontab #{fetch :whenever_identifier}" }

    end
  end

  # make sure we're deploying what we think we're deploying
  before :deploy, "deploy:check_revision"
  after :deploy, "deploy:setup_config"
  after :finishing, 'deploy:cleanup'

  # reload nginx to it will pick up any modified vhosts from
  # setup_config
  # after 'deploy:setup_config', 'nginx:reload'

  # As of Capistrano 3.1, the `deploy:restart` task is not called
  # automatically.
  after 'deploy:publishing', 'deploy:restart'

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end

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
      execute "ln -sf #{shared_path}/application.yml #{current_path}/config/application.yml"
    end
  end
end
after "deploy:started", "figaro:setup"
after "deploy:symlink:release", "figaro:symlink"

namespace :deploy do
  desc "checks whether the currently checkout out revision matches the
        remote one we're trying to deploy from"
  task :check_revision do
    branch = fetch(:branch)
    unless `git rev-parse HEAD` == `git rev-parse origin/#{branch}`
      puts "WARNING: HEAD is not the same as origin/#{branch}"
      puts "Run `git push` to sync changes or make sure you've"
      puts "checked out the branch: #{branch} as you can only deploy"
      puts "if you've got the target branch checked out"
      exit
    end
  end
end

# namespace :deploy do
#   on roles(:app) do
#     # Setup logs
#     execute "ln -s  #{shared_path}/log #{release_path}"
#   end
# end
