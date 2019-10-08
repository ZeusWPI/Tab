class UserBankTransferRequestsController < ApplicationController
  load_and_authorize_resource :user, find_by: :name

  before_action :load_bank_transfer_request, only: [:cancel]
  authorize_resource :bank_transfer_request, id_param: :bank_transfer_request_id, only: [:cancel]

  def index
    @bank_transfer_requests = @user.bank_transfer_requests
  end

  def cancel
    @bank_transfer_request.cancel!
    redirect_to action: :index
  end

  private

  def load_bank_transfer_request
    @bank_transfer_request = BankTransferRequest.find params[:bank_transfer_request_id]
  end
end
