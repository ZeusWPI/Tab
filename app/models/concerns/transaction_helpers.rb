# frozen_string_literal: true

module TransactionHelpers
  include ActiveSupport::Concern

  def peer_of(user)
    return creditor if user == debtor
    return debtor   if user == creditor
  end

  def client_transaction?
    issuer_type == "Client"
  end
end
