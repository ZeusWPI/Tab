class BankTransferRequestsController < ApplicationController
  load_and_authorize_resource :user, find_by: :name

  before_action :load_bank_transfer_request, only: [:cancel]
  authorize_resource :bank_transfer_request, id_param: :bank_transfer_request_id, only: [:cancel]

  def index
    @bank_transfer_requests = @user.bank_transfer_requests
    @bank_transfer_request = BankTransferRequest.new
  end

  def create
    @bank_transfer_request = BankTransferRequest.new(
      create_params.merge(user: @user)
    )
    @bank_transfer_request.set_payment_code

    if @bank_transfer_request.save
      flash[:success] = "Bank transfer request ##{@bank_transfer_request.id} with payment code <strong>#{@bank_transfer_request.payment_code}</strong> created. Use this payment code in the description field of your bank transaction.".html_safe
      @bank_transfer_request = BankTransferRequest.new
    end

    @bank_transfer_requests = @user.bank_transfer_requests
    render :index
  end

  def cancel
    if @bank_transfer_request.cancellable?
      @bank_transfer_request.cancel!
    else
      flash[:warning] = "This bank transfer request is not cancellable."
    end

    redirect_to action: :index
  end

  private

  def load_bank_transfer_request
    @bank_transfer_request = BankTransferRequest.find params[:bank_transfer_request_id]
  end

  def create_params
    params.require(:bank_transfer_request).permit(:amount)
  end
end
