APP_DIR="/home/deploy/eecshelp"

task :deploy do
  run_command "git pull origin master && bundle install && rake db:migrate assets:precompile"
end

namespace :deploy do
  task :restart do
    run_command "sudo restart puma app=#{APP_DIR}"
  end
end

def run_command(command)
    sh "ssh eecshelp \"cd #{APP_DIR} && #{command}\""
end
