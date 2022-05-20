class DatatablesController < ApplicationController
  load_and_authorize_resource :user, find_by: :id

  before_action :load_notification, only: :read
  authorize_resource :user, only: :read
  respond_to :json

  def transactions_for_user
    user = User.find_by(name: params[:id])
    authorize! :read, user

    render json: DataTable.new(user, params)
  end
end
