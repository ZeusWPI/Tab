class UsersController < ApplicationController
  load_and_authorize_resource

  include DataTable

  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: apply_filter(@user, params) }
    end
  end

  def index
    @users = User.all
  end
end
