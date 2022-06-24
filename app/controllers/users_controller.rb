# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  load_and_authorize_resource find_by: :name

  def show
    @user = User.find_by(name: params[:id]) || User.new
    authorize! :read, @user

    @transaction = Transaction.new
  end

  def index
    @users = User.accessible_by(current_ability)
  end

  def reset_key
    @user.generate_key!
    redirect_to @user
  end
end
