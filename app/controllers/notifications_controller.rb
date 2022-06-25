# frozen_string_literal: true

class NotificationsController < ApplicationController
  load_and_authorize_resource :user, find_by: :name

  before_action :load_notification, only: :read
  authorize_resource :notification, only: :read

  def index
    @notifications = @user.notifications.group_by(&:read)
  end

  def read
    @notification.read!

    flash[:success] = "Notification marked as read!"

    redirect_back_or_to root_path
  end

  private

  def load_notification
    @notification = Notification.find params[:notification_id]
  end
end
