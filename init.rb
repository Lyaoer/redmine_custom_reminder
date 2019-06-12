require 'redmine'
require 'redmine_custom_reminder/hooks'
require 'redmine_custom_reminder/version'

ActionView::Base.send(:include, RedmineCustomReminder::RenderHelper) unless ActionView::Base.include?(RedmineCustomReminder::RenderHelper)

Redmine::Plugin.register :redmine_custom_reminder do
  name 'Redmine Custom Email Reminder'
  author 'Andrey Lobanov(RedSoft)'
  description 'Sends email notifications by custom conditions'
  version RedmineCustomReminder::Version.to_s

  permission :manage_project_custom_reminders, {}, require: :member

  menu :admin_menu,
       :custom_reminder,
       { controller: 'custom_reminders', action: :index },
       if: proc { User.current.admin? },
       caption: :label_custom_reminders_plural,
       html: { class: 'icon icon-custom_reminder' }

  settings :default => {'task_time'=>'0 8 * * *'}

  def start_reminder
    require 'rufus-scheduler'
    if !$time_reminder.present?
      @init_reminder ||= Rufus::Scheduler.new
      @init_reminder.in '1m' do
        TimingCustomRemindersController.new.reminder_timing()
      end
    end
  end

  start_reminder()
end
