class TransactionsController < ApplicationController

  def index
    p params
    respond_to do |format|
      format.html
      format.json { render json: TransactionDatatable.new(view_context) }
    end
  end

  def new
    @transaction = Transaction.new
  end

  def create
  end

end
