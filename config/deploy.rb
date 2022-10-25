# config valid for current version and patch releases of Capistrano
# lock "~> 3.17.0"

set :application, "Tab"
set :repo_url, "https://github.com/ZeusWPI/Tab.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/tab/production'

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", 'config/master.key'
append :linked_files, "config/database.yml", "config/secrets.yml", ".env"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "tmp/webpacker", "public/system", "vendor", "storage"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

namespace :deploy do
  desc 'Generate swagger docs'
  task :'swaggerize:generate' do
    run_locally do
      # Bit ugly, but sadly capistrano-asdf has no support for run_locally
      # and would prefix this with `asdf.sh`, causing it to fail.
      # Not going to bother fixing it properly as we'll move to
      # capistrano-docker soon(tm).
      %x(bundle exec rake rswag:specs:swaggerize)
    end
  end

  desc 'Coppy swagger docs'
  task :'swaggerize:copy' do
    on roles(:app) do
      within release_path do
        %w[swagger].each do |dir|
          upload! dir, dir, recursive: true
        end
      end
    end
  end
end

before 'deploy:check', 'deploy:swaggerize:generate'
after 'deploy:migrate', 'deploy:swaggerize:copy'
