class DatatablesController < ApplicationController
  respond_to :json

  def transactions_for_user
    user = User.find(params[:id])
    datatable = DataTable.new(user, params)
    render json: datatable.json
  end
end
