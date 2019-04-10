class TransactionsController < ApplicationController
  load_and_authorize_resource :user, find_by: :name

  def index
    @transactions = @user.transactions
    respond_to do |format|
      format.json { render json: @transactions }
    end
  end

  def create
    @transaction = Transaction.new(transaction_params)
    @transaction.reverse if @transaction.amount < 0

    unless can? :create, @transaction
      @transaction = Request.new @transaction.info
      authorize!(:create, @transaction)
    end

    if @transaction.save
      respond_to do |format|
        format.html { redirect_to root_path }
        format.json { render json: @transaction, status: :created }
      end
    else
      respond_to do |format|
        format.html { redirect_to root_path }
        format.json { render json: @transaction.errors.full_messages,
        status: :unprocessable_entity }
      end
    end
  end

  private

  def transaction_params
    t = params.require(:transaction)
          .permit(:debtor, :creditor, :message, :euros, :cents, :id_at_client)

    {
      debtor: t[:debtor] ? User.find_or_create_by(name: t[:debtor]) : User.zeus,
      creditor: t[:creditor] ? User.find_or_create_by(name: t[:creditor]) : User.zeus,
      issuer: current_client || current_user,
      amount: (t[:euros].to_f * 100 + t[:cents].to_f).to_i,
      message: t[:message],
    }.merge(current_client ? { id_at_client: t[:id_at_client] } : {})
  end
end
