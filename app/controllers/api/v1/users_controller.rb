# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      load_resource :user, find_by: :name, only: [:show]

      def index
        @users = User.all

        if can?(:manage, :all)
          render json: @users.to_json(except: [:key])
        else
          render json: @users.to_json(only: [:id, :name])
        end
      end

      def show
        if can?(:read, @user)
          render json: @user.to_json(except: [:key])
        else
          render json: @user.to_json(only: [:id, :name])
        end
      end
    end
  end
end
