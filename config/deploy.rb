# config valid only for Capistrano 3.1
lock '3.2.1'

##################################################################
###  fritza - 9-Jun-2014                                       ###
###  This file is laid out according to the suggestions in an  ###
###  [online tutorial](http://robmclarty.com/blog/how-to-deploy-a-rails-4-app-with-git-and-capistrano). The versions don’t match up, so this may ###
###  not refect the best advice. But it’s a start, and we can  ###
###  pick it up with more research (and, I fear, experience).  ###
###                                                            ###
###  Settings in the tutorial but not in the template can be   ###
###  found later in this file. I’m assuming they’re            ###
###  used/legal/necessary until I find otherwise.              ###
##################################################################



set :application, 'party-planner'

set :scm, :git
set :branch 'Capistrano'    # This should change later
set :repo_url, 'git@github.com:fritza/party-planner.git'

# Default deploy_to directory is /var/www/my_app
# fritza - 9-Jun-2014 - Put it into the `planner` tree
set :deploy_to, '/Users/planner/party-planner'
# fritza - 9-Jun-2014 - Is this supposed to be the full URL?
server "fritzanderson.uchicago.edu", :web, :app, :db, primary: true



##################################################################
###  fritza - 9-Jun-2014                                       ###
###  The following were not in the boilerplate for this file,  ###
###  but were in [the tutorial](http://robmclarty.com/blog/how-to-deploy-a-rails-4-app-with-git-and-capistrano).  ###
###  I’m assuming they’re used/legal/necessary until I find    ###
###  otherwise.                                                ###
##################################################################

# fritza - 9-Jun-2014 - In the tutorial, not in the default listing here.
#     Username for the account installing the app in the host machine.
set :user, 'planner'
set :deploy_user, 'planner'

# fritza - 9-Jun-2014 - In the tutorial, not in the default listing here.
set :rails_env, :production

# fritza - 9-Jun-2014 - The process is all in `planner`, right? No need for sudo?
set :use_sudo, false
# *On the other hand,* if Capistrano uses brew to install MySQL, it needs sudo.
# However, that’s going to be more trouble than it’s worth. You can expect the
# real pilot installation will start from having MySQL.

# The tutorial says this pulls origin into the local machine, which
# then sends the entire app to the server. There’s an alternative,
# having the server do the pull itself (:remote_cache), which I
# think has much more point, but at the first cut, we’ll do it his way.
set :deploy_via :copy


### From the [Capistrano 3 Tutorial](http://www.talkingquickly.co.uk/2014/01/deploying-rails-apps-to-a-vps-with-capistrano-v3/)
### It’s supposed to support RVM.

set :rbenv_type, :system
set :rbenv_ruby, '4.1.1'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}


##################################################################
###  End of “undocumented” customizations.                     ###
##################################################################



# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

namespace :deploy do
  
  require 'rvm/capistrano'
  
  set :rvm_ruby_string, :local
  before 'deploy', 'rvm:install_rvm'
  before 'deploy', 'rvm:install_ruby'

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
