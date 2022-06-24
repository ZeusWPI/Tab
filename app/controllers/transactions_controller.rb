# frozen_string_literal: true

class TransactionsController < ApplicationController
  load_and_authorize_resource :user, find_by: :name

  def create
    @transaction = Transaction.new(transaction_params)
    @transaction.reverse if @transaction.amount.negative?

    @transaction = Request.new(@transaction.info) if action_param[:action].to_sym == :request

    authorize!(:create, @transaction)

    if @transaction.save
      flash[:success] =
        if @transaction.is_a?(Transaction)
          "Transaction created!"
        else
          "Request made!"
        end
    else
      flash[:error] = "Something went wrong, hope this helps: #{@transaction.errors.full_messages}"
    end

    redirect_to root_path
  end

  private

  def transaction_params
    t = params.require(:transaction).permit(:debtor, :creditor, :message, :euros, :cents)

    {
      debtor: User.find_by(name: t[:debtor]),
      creditor: User.find_by(name: t[:creditor]),
      issuer: current_user,
      amount: ((BigDecimal(t[:euros] || 0, 2) * 100) + t[:cents].to_i).to_i,
      message: t[:message],
    }
  end

  def action_param
    params.require(:transaction).permit(:action)
  end
end
