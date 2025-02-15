# frozen_string_literal: true

module Api
  module V1
    class TransactionsController < Api::V1::ApplicationController
      load_and_authorize_resource :user, find_by: :name

      def index
        transactions = @user.transactions
                            .order("updated_at desc")
                            .offset(params[:start])
                            .limit(params[:limit])
                            .includes(:debtor, :creditor, :issuer)

        mapped_transactions = transactions.map do |t|
          {
            id: t.id,
            debtor: t.debtor.name,
            creditor: t.creditor.name,
            time: t.updated_at,
            amount: t.amount,
            message: t.message,
            issuer: t.issuer.name
          }
        end

        render json: mapped_transactions
      end

      def create
        @transaction = Transaction.new(transaction_params)
        @transaction.reverse if @transaction.amount.negative?

        unless can? :create, @transaction
          @transaction = Request.new @transaction.info
          authorize!(:create, @transaction)
        end

        if @transaction.save
          render json: @transaction, status: :created
        else
          render json: @transaction.errors.full_messages, status: :unprocessable_entity
        end
      end

      private

      def transaction_params
        t = params.require(:transaction).permit(:debtor, :creditor, :message, :euros, :cents, :id_at_client)

        {
          debtor: t[:debtor] ? User.find_by(name: t[:debtor]) : User.zeus,
          creditor: t[:creditor] ? User.find_by(name: t[:creditor]) : User.zeus,
          issuer: current_user_or_client,
          amount: ((BigDecimal(t[:euros]&.to_s || "0") * 100) + t[:cents].to_i).to_i,
          message: t[:message],
        }.merge(current_client ? { id_at_client: t[:id_at_client] } : {})
      end
    end
  end
end
