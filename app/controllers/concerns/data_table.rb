
module DataTable
  extend ActiveSupport::Concern

  def apply_filter(user, params)
    p AjaxRequest.new(params)
    selection_to_json(user, user.transactions)
  end

  private

  class AjaxRequest

    def initialize(params)
      # Parsing according to https://datatables.net/manual/server-side
      @draw = params.require(:draw).to_i
      @start = params.require(:start).to_i
      @length = params.require(:length).to_i
      @columns = Hash.new
      params.require(:columns).each do |i, column|
        @columns[column.require(:data).to_sym] = {
          name: column[:name],
          searchable: column[:searchable] == 'true',
          orderable: column[:orderable] == 'true',
          search_value: column.require(:search)[:value]
        }
      end
    end

  end

  def selection_to_json(user, selection)
    { data: selection.map { |transaction| {
        time: transaction.created_at,
        amount: transaction.signed_amount_for(user),
        peer: transaction.peer_of(user).try(:name),
        issuer: transaction.issuer.name,
        message: transaction.message,
      } }
    }
  end
end

