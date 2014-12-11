# config valid only for Capistrano 3.2.1
lock '3.2.1'

set :application, '<%= capprojectname %>'
set :repo_url, 'git@git.snpdev.ru:saltpepper/<%= capprojectname %>-frontend.git'

set :commit_id, ENV['CI_COMMIT_ID'] || ENV['CI_BUILD_SHA']

if fetch(:commit_id).nil?
  ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call
else
  set :branch, fetch(:commit_id)
end

set :deploy_to, "/var/www/#{application}/cs"

set :linked_dirs, fetch(:linked_dirs, []).push('node_modules')

set :nvm_type, :user
set :nvm_node, '0.10'
set :nvm_map_bins, %w{node npm grunt bower}

set :npm_flags, '--silent'

set :grunt_tasks, 'build:dist'

before 'deploy:updated', 'grunt'
