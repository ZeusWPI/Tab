# frozen_string_literal: true

class ReminderMailer < ApplicationMailer
  def request_reminder
    @user = User.find(params[:user_id])
    @requests = @user.incoming_requests.open
    mail(to: "#{@user.name}@zeus.ugent.be", subject: "Tab: Monthly request reminders")
  end
end
