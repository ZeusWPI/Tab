# frozen_string_literal: true

class MonthlyReminder
  include Sidekiq::Worker

  def perform(*_args)
    people = Request.all.group_by(&:debtor_id)
    people.each_key do |debtor_id|
      ReminderMailer.with(user_id: debtor_id).request_reminder.deliver_later
    end
  end
end
