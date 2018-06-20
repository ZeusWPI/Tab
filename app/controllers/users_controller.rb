class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create, find_by: :name

  before_action :authenticate_user!, except: :show
  before_action :authenticate_user_or_client!, only: :show

  load_and_authorize_resource except: :show

  def show
    @user = User.find_by(name: params[:id]) || User.new
    authorize! :read, @user
    respond_to do |format|
      format.html { @transaction = Transaction.new }
      format.json { render json: @user }
    end
  end

  def index
    @users = User.all
  end
end
