# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  load_and_authorize_resource find_by: :name

  def index
    @sort_column = params[:order_by]
    @sort_column = "balance" unless %w[name balance].include?(@sort_column)
    @users = User.accessible_by(current_ability).order({ @sort_column => :asc })
  end

  def show
    @user = User.find_by(name: params[:id]) || User.new
    authorize! :read, @user

    @transaction = Transaction.new
  end

  def reset_key
    @user.generate_key!
    redirect_to @user
  end
end
