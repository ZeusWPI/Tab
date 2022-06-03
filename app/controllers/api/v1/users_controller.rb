module Api
  module V1
    class UsersController < ApplicationController

      load_resource :user, find_by: :name

      def show
        if can?(:read, @user)
          render json: @user
        else
          render json: @user.to_json(only: [:id, :name])
        end
      end

      def index
        @users = User.all

        if can?(:manage, :all)
          render json: @users
        else
          render json: @users.to_json(only: [:id, :name])
        end
      end
    end
  end
end
