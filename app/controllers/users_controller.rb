class UsersController < ApplicationController
  load_and_authorize_resource

  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html do
        @transaction = Transaction.new
      end
      format.json do
        datatable = DataTable.new(@user, params)
        render json: datatable.json
      end
    end
  end

  def index
    @users = User.all
  end
end
