class UsersController < ApplicationController
  load_and_authorize_resource

  def show
    @user = User.find(params[:id])
    @transaction = Transaction.new

    gridparams = params[:transactions_grid] || Hash.new
    gridparams = gridparams.merge(
      order: :created_at,
      descending: true,
      current_user: current_user
    )
    @grid = TransactionsGrid.new(gridparams) do |scope|
      scope.where('debtor_id = :id OR creditor_id = :id', id: current_user).page(params[:page])
    end
  end

  def index
    @users = User.all
  end
end
