class TransactionsController < ApplicationController
  def index
    @transactions = Transaction.all
  end

  def new
    @transaction = Transaction.new
  end

  def create
    @transaction = current_user.outgoing_transactions.build(
      transaction_params.merge(origin: I18n.t('origin.created_by_user')))

    if @transaction.save
      redirect_to current_user
    else
      render 'new'
    end
  end

  private

  def set_params
    t = params.require(:transaction)
          .permit(:debtor, :creditor, :amount, :message)

    t.update {
      debtor: User.find_by(name: t[:debtor]) || User.zeus,
      creditor: User.find_by(name: t[:creditor]) || User.zeus
    }
  end
end
