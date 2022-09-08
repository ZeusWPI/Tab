# frozen_string_literal: true

module Api
  module V1
    class RequestsController < Api::V1::ApplicationController
      load_and_authorize_resource :user, find_by: :name
      before_action :load_request, only: [:confirm, :decline, :cancel]
      authorize_resource :request, id_param: :request_id, only: [:confirm, :decline, :cancel]

      def index
        @requests = current_user.requests.includes(:debtor, :creditor, :issuer)

        # If there is no param, return now.
        return unless params.key?(:state)

        # If there is a bad param, bail with 400.
        return head :bad_request unless %w[open confirmed declined cancelled].include?(params[:state])

        # Dynamically call the pending or final scope.
        @requests = @requests.send(params[:state])
      end

      def confirm
        @request.confirm!
        head :no_content
      end

      def decline
        @request.decline!
        head :no_content
      end

      def cancel
        @request.cancel!
        head :no_content
      end

      private

      def load_request
        @request = Request.find params[:request_id]
      end
    end
  end
end
