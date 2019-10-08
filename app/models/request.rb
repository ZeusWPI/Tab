# == Schema Information
#
# Table name: requests
#
#  id          :integer          not null, primary key
#  debtor_id   :integer          not null
#  creditor_id :integer          not null
#  issuer_type :string           not null
#  issuer_id   :integer          not null
#  amount      :integer          default(0), not null
#  message     :string
#  status      :integer          default("open")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Request < ApplicationRecord
  include BaseTransaction

  enum status: [:open, :confirmed, :declined, :cancelled]

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

  def cancel!
    return unless open?

    Notification.create user: creditor, message: cancelled_message unless issuer == creditor
    Notification.create user: debtor, message: cancelled_message unless issuer == debtor

    update_attributes status: :cancelled
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
