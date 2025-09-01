# frozen_string_literal: true

class MonthlyReminder
  include Sidekiq::Worker

  def perform(*_args)
    debtor_ids = Request.open.pluck(:debtor_id).uniq
    debtor_ids.each do |debtor_id|
      ReminderMailer.with(user_id: debtor_id).request_reminder.deliver_later
    end
  end
end
