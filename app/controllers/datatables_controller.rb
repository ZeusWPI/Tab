# frozen_string_literal: true

class DatatablesController < ApplicationController
  load_and_authorize_resource :user, find_by: :id

  authorize_resource :user, only: :read
  respond_to :json

  def transactions_for_user
    user = User.find_by(name: params[:id])
    authorize! :read, user
    datatable = DataTable.new(user, params)
    render json: datatable.json
  end
end
