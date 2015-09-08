class TransactionsController < ApplicationController

  def index
    @transactions = Transaction.all
  end

  def new
    @transaction = Transaction.new
  end

  def create
    creditor = User.find params.require(:transaction).require(:creditor)
    debtor = current_user
    amount = params.require(:transaction).require(:amount)
    @transaction = Transaction.create debtor: debtor, creditor: creditor, amount: amount, origin: I18n.t('origin.created_by_user'), message: "Transaction by #{debtor.name} to #{creditor.name}"
  end

end
