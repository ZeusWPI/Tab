
module DataTable
  extend ActiveSupport::Concern

  def apply_filter(user, params)
    params = sanitize_params(params)
    selection_to_json(user, params[:draw], user.transactions)
  end

  private

  def sanitize_params(params)
    # Parsing according to https://datatables.net/manual/server-side
    clean = {
      draw: params.require(:draw).to_i,
      start: params.require(:start).to_i,
      length: params.require(:length).to_i,
      columns: Hash.new
    }
    params.require(:columns).each do |i, column|
      type, value = column.require(:search)[:value].split(':')
      h = clean[:columns][column.require(:data).to_sym] = {
        name: column[:name],
        searchable: column[:searchable] == 'true',
        orderable: column[:orderable] == 'true',
        type: type
      }
      if type == 'number-range'
        h[:lower], h[:upper] = value.split('~').map &:to_i
      elsif type == 'date-range'
        h[:lower], h[:upper] = value.split('~').map &:to_datetime
      else
        h[:value] = value
      end
    end
    return clean
  end

  def selection_to_json(user, draw, selection)
    selection = selection.to_a
    {
      draw: draw,
      recordsTotal: user.transactions.count,
      recordsFiltered: selection.count,
      data: selection.map { |transaction| {
        time: transaction.created_at,
        amount: transaction.signed_amount_for(user),
        peer: transaction.peer_of(user).try(:name),
        issuer: transaction.issuer.name,
        message: transaction.message,
      }}
    }
  end
end

