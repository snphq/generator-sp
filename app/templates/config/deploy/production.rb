# production.rb
set :rails_env, :production

# Настраиваем ssh до сервера
server "<--input production host-->", :app, :web, :db, :primary => true

# Авторизационные данные
set :user, "<%= capprojectname %>"
set :group, "<%= capprojectname %>"
set :password, '<--password-->'
set :keep_releases, 10
