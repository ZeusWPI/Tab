class TransactionsController < ApplicationController
  def index
    @transactions = Transaction.all
  end

  def new
    @transaction = Transaction.new
  end

  def create
    @transaction = Transaction.new(set_params.merge(origin: I18n.t('origin.created_by_user')))

    if @transaction.save
      respond_to do |format|
        format.html { redirect_to root_path }
        format.json { head :created }
      end
    else
      render 'new'
    end
  end

  private

  def set_params
    t = params.require(:transaction)
          .permit(:debtor, :creditor, :amount, :message)

    t.update({
      debtor: User.find_by(name: t[:debtor]) || User.zeus,
      creditor: User.find_by(name: t[:creditor]) || User.zeus
    })
  end
end
