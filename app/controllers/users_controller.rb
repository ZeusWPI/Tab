class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :create

  before_action :authenticate_user!, except: :show
  before_action :authenticate_user_or_client!, only: :show

  load_and_authorize_resource except: :show

  def show
    @user = User.find_by(name: params[:id]) || User.new
    respond_to do |format|
      format.html { @transaction = Transaction.new }
      format.json { render json: @user }
    end
  end

  def index
    @users = User.all
  end
end
