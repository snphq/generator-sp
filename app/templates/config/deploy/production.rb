role :web, %w(<%= capprojectname %>@<--input production host-->)

set :grunt_tasks, 'build:production'
