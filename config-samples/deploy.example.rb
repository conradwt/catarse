set :application, 'put_your_application_name_here'
set :user, 'put_your_hosting_rails_user_name_here'
set :domain, 'put_your_hosting_rails_server_name_here'
set :mongrel_port, 'put_your_assigned_mongrel_port_number_here'
set :server_hostname, 'your_application_url.com'

set :git_account, 'put_your_git_account_name_here'

set :scm_passphrase,  Proc.new { Capistrano::CLI.password_prompt('Git Password: ') }

role :web, server_hostname
role :app, server_hostname
role :db, server_hostname, :primary => true

default_run_options[:pty] = true
set :repository,  "git@github.com:#{git_account}/#{application}.git"
set :scm, "git"
set :user, user

ssh_options[:forward_agent] = true
set :branch, "master"
set :deploy_via, :remote_cache
set :git_shallow_clone, 1
set :git_enable_submodules, 1
set :use_sudo, false
set :deploy_to, "/home/#{user}/#{application}"