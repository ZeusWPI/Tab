class UsersController < ApplicationController
  load_and_authorize_resource

  def show
    @user = User.find(params[:id])
    @transaction = Transaction.new
    respond_to do |format|
      format.html
      format.json { render json: TransactionDatatable.new(
        view_context, {user: @user})
      }
    end
  end

  def index
    @users = User.all
  end
end
