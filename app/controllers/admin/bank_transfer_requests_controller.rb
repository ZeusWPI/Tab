class Admin::BankTransferRequestsController < AdminController
  before_action :load_bank_transfer_request, only: [:approve, :decline]
  authorize_resource :bank_transfer_request, id_param: :bank_transfer_request_id, only: [:approve, :decline]

  def index
    @bank_transfer_requests = BankTransferRequest.all
  end

  def approve
    if @bank_transfer_request.approvable?
      @bank_transfer_request.approve!
    else
      flash[:warning] = "This bank transfer request is not approvable."
    end

    redirect_to action: :index
  end

  def decline
    if @bank_transfer_request.declinable?
      @bank_transfer_request.decline!(params[:reason])
    else
      flash[:warning] = "This bank transfer request is not declinable."
    end
    redirect_to action: :index
  end

  private

  def load_bank_transfer_request
    @bank_transfer_request = BankTransferRequest.find params[:bank_transfer_request_id]
  end
end
