class TransactionsController < ApplicationController

  def index
    respond_to do |format|
      format.html
      format.json { render json: TransactionDatatable.new(view_context) }
    end
  end

  def new
    @transaction = Transaction.new
  end

  def create
    @transaction = current_user.outgoing_transactions.build transaction_params.merge(origin: I18n.t('origin.created_by_user'))

    if @transaction.save
      redirect_to current_user
    else
      render 'new'
    end
  end

  private

  def transaction_params
    params.require(:transaction).permit(:creditor_id, :amount, :message)
  end
end
