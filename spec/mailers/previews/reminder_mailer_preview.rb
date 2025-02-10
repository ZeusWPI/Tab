# Preview all emails at http://localhost:3000/rails/mailers/reminder_mailer
class ReminderMailerPreview < ActionMailer::Preview
  def request_reminder
    ReminderMailer.with(user_id: User.first.id).request_reminder
  end
end
