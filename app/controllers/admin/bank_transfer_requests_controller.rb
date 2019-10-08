class Admin::BankTransferRequestsController < AdminController
  before_action :load_bank_transfer_request, only: [:approve, :decline]
  authorize_resource :bank_transfer_request, id_param: :bank_transfer_request_id, only: [:approve, :decline]

  def index
    @bank_transfer_requests = BankTransferRequest.all
  end

  def approve
    @bank_transfer_request.approve!
    redirect_to action: :index
  end

  def decline
    @bank_transfer_request.decline!
    redirect_to action: :index
  end

  private

  def load_bank_transfer_request
    @bank_transfer_request = BankTransferRequest.find params[:bank_transfer_request_id]
  end
end
