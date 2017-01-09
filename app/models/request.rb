class Request < ActiveRecord::Base
  include BaseTransaction

  enum status: [:open, :confirmed, :declined]

  def confirm!
    return unless open?

    Transaction.create info
    Notification.create user: creditor,message: confirmed_message

    update_attributes status: :confirmed
  end

  def decline!
    return unless open?

    Notification.create user: creditor, message: declined_message

    update_attributes status: :declined
  end

  private

  def confirmed_message
    "Your request for €#{amount/100.0} for \"#{message}\" has been accepted by #{debtor.name}."
  end

  def declined_message
    "#{debtor.name} refuses to pay €#{amount/100.0} for \"#{message}\"."
  end
end
