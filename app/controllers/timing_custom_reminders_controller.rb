class TimingCustomRemindersController < ApplicationController
  require 'rufus-scheduler'

  @@time_reminder = nil

  def reminder_timing()
    if !@@time_reminder.present?
      @@time_reminder = Rufus::Scheduler.new
      @@time_reminder.cron "#{Setting.plugin_redmine_custom_reminder['task_time']}  Asia/Shanghai" do
        CustomRemindersEmailNotificationJob.perform_now
      end
    else
      @@time_reminder.shutdown(:kill)
      @@time_reminder = Rufus::Scheduler.new
      @@time_reminder.cron "#{Setting.plugin_redmine_custom_reminder['task_time']}  Asia/Shanghai" do
        CustomRemindersEmailNotificationJob.perform_now
      end
    end
  end
end