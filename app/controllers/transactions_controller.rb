class TransactionsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :create

  before_action :authenticate_user!, except: :create
  before_action :authenticate_user_or_client!, only: :create

  # This line MUST be placed after authentication
  load_and_authorize_resource

  def index
    gridparams = params[:transactions_grid] || Hash.new
    gridparams = gridparams.merge(
      order: :created_at,
      descending: true,
      current_user: current_user
    )
    @grid = TransactionsGrid.new(gridparams) do |scope|
      scope.page(params[:page])
    end
  end

  def create
    transaction = Transaction.new(transaction_params)
    if transaction.save
      head :created
    else
      render json: transaction.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def transaction_params
    t = params.require(:transaction)
          .permit(:debtor, :creditor, :message, :euros, :cents)

    {
      debtor: User.find_by(name: t[:debtor]) || User.zeus,
      creditor: User.find_by(name: t[:creditor]) || User.zeus,
      issuer: current_client || current_user,
      amount: (float(t[:euros]) * 100 + float(t[:cents])).to_i,
      message: t[:message]
    }
  end

  def float arg
    if arg.is_a? String then arg.sub!(',', '.') end
    arg.to_f
  end
end
