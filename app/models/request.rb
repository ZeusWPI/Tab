# == Schema Information
#
# Table name: requests
#
#  id          :integer          not null, primary key
#  debtor_id   :integer          not null
#  creditor_id :integer          not null
#  issuer_id   :integer          not null
#  issuer_type :string           not null
#  amount      :integer          default(0), not null
#  message     :string
#  status      :integer          default(0)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Request < ActiveRecord::Base
  include BaseTransaction

  enum status: [:open, :confirmed, :declined, :cancelled]

  def confirm!
    return unless open?

    Transaction.create info
    Notification.create user: creditor, message: confirmed_message

    self.confirmed!
  end

  def decline!
    return unless open?

    Notification.create user: creditor, message: declined_message

    self.declined!
  end

  def cancel!
    return unless open?

    Notification.create user: creditor, message: cancelled_message unless issuer == creditor
    Notification.create user: debtor, message: cancelled_message unless issuer == debtor

    self.cancelled!
  end

  private

  def confirmed_message
    "Your request for €#{amount/100.0} for \"#{message}\" has been accepted by #{debtor.name}."
  end

  def declined_message
    "#{debtor.name} refuses to pay €#{amount/100.0} for \"#{message}\"."
  end

  def cancelled_message
    "#{issuer.name} cancelled the request to pay #{debtor.name} €#{amount/100.0} for \"#{message}\" to #{creditor.name}."
  end
end
