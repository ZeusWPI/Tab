class TransactionsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :create

  before_action :authenticate_user!, except: :create
  before_action :authenticate_user_or_client!, only: :create

  def index
    @transactions = Transaction.all
  end

  def new
    @transaction = Transaction.new
  end

  def create
    @transaction = Transaction.new(transaction_params)
    respond_to do |format|
      format.html do
        if @transaction.save
          flash[:success] = "Transaction created"
          redirect_to new_transaction_path
        else
          render 'new'
        end
      end

      format.json do
        head(@transaction.save ? :created : :unprocessable_entity)
      end
    end
  end

  private

  def transaction_params
    t = params.require(:transaction)
          .permit(:debtor, :creditor, :amount, :message)

    t.update({
      debtor: User.find_by(name: t[:debtor]) || User.zeus,
      creditor: User.find_by(name: t[:creditor]) || User.zeus,
      issuer: current_client || current_user
    })
  end
end
