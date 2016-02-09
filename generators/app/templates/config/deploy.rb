require 'capistrano/ext/multistage'

set :stages, %w(testing production)
set :default_stage, 'testing'

set :application, "<%= capprojectname %>"

set :deploy_to, "/var/www/#{application}/cs"
set :use_sudo, false
set :deploy_via, :copy
set :scm, :none

# Deploy hooks
after 'deploy:update', 'deploy:cleanup'
