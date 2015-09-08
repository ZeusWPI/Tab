module TransactionsHelper
  def get_transaction_peer(transaction, user)
    return transaction.creditor if user == transaction.debtor
    return transaction.debtor if user == transaction.creditor
  end

  def amount_in_perspective(transaction, user)
    return -transaction.amount if user == transaction.debtor
    return transaction.amount if user == transaction.creditor
  end
end
