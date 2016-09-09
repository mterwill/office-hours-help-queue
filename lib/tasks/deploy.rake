ENV_FILE="/home/deploy/.profile"
APP_ROOT="/home/deploy/eecshelp"

task :deploy do
  commands = [
    "source #{ENV_FILE}",
    "cd #{APP_ROOT}",
    "git pull origin master",
    "sudo chown -R deploy:www-data .",
    "bundle install",
    "rake db:migrate",
    "rake tmp:cache:clear",
    "rake assets:precompile",
    "sudo restart puma app=#{APP_ROOT}",
  ].join(" && ")

  sh "ssh eecshelp \"#{commands}\""
end

task :console do
  commands = [
    "source #{ENV_FILE}",
    "cd #{APP_ROOT}",
    "bundle exec rails c",
  ].join(" && ")

  sh "ssh eecshelp -t \"#{commands}\""
end
