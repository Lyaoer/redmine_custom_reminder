set :output, error: '/opt/redmine-4.0.2/log/cron.stderr.log', standard: '/opt/redmine-4.0.2/log/cron.stdout.log'
%w[PATH BUNDLE_PATH GEM_HOME RAILS_ENV PWD GEM_PATH].each do |envir|
  env(envir, ENV[envir])
end

every :day, at: '10am' do
  runner 'CustomRemindersEmailNotificationJob.perform_now'
end