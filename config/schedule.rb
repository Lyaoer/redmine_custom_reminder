set :output, error: '/home/red2mine/red2mine/log/cron.stderr.log', standard: '/home/red2mine/red2mine/log/cron.stdout.log'
%w[PATH BUNDLE_PATH GEM_HOME RAILS_ENV PWD GEM_PATH].each do |envir|
  env(envir, ENV[envir])
end
job_type :custom_runner, "cd :path && bundle exec rails runner -e :environment ':task' :output"

every :day, at: '10am' do
  custom_runner 'CustomRemindersJob.perform_now'
end