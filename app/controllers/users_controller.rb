# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show, :add_registration_token]
  before_action :authenticate_user_or_client!, only: [:show, :add_registration_token]

  load_and_authorize_resource find_by: :name

  def show
    @user = User.find_by(name: params[:id]) || User.new
    authorize! :read, @user
    respond_to do |format|
      format.html { @transaction = Transaction.new }
      format.json { render json: @user.to_json(except: [:key]) }
    end
  end

  def index
    @users = User.accessible_by(current_ability)
  end

  def reset_key
    @user.generate_key!
    redirect_to @user
  end

  def add_registration_token
    token = JSON.parse(request.raw_post)["token"]
    respond_to do |format|
      format.json { render json: AndroidDeviceRegistrationToken.create(user: @user, token:) }
    end
  end
end
