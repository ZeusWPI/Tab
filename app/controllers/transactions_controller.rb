class TransactionsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :create

  before_action :authenticate_user!, except: :create
  before_action :authenticate_user_or_client!, only: :create
  respond_to :js, only: :create

  def create
    @transaction = Transaction.new(transaction_params)
    @transaction.reverse if @transaction.amount < 0
    authorize!(:create, @transaction)

    if @transaction.save
      head :created
    else
      render json: @transaction.errors.full_messages,
        status: :unprocessable_entity
    end
  end

  private

  def transaction_params
    t = params.require(:transaction)
          .permit(:debtor, :creditor, :message, :euros, :cents)

    {
      debtor: t[:debtor] ? User.find_or_create_by(name: t[:debtor]) : User.zeus,
      creditor: t[:creator] ? User.find_or_create_by(name: t[:creditor]) : User.zeus,
      issuer: current_client || current_user,
      amount: (t[:euros].to_f*100 + t[:cents].to_f).to_i,
      message: t[:message]
    }
  end
end
