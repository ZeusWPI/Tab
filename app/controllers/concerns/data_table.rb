class DataTable

  def initialize user, params
    @user = user
    @params = sanitize_params(params)
    @transactions = TransactionsQuery.new(@user)
    @table = @transactions.arel_table
  end

  def json
    response_json(@params[:draw], data)
  end

  def data
    ActiveRecord::Base.connection.execute(self.query.to_sql)
  end

  def query
    pred = predicates
    q = @transactions.query
    q = q.where(pred) if pred
    q
  end

  def predicates
    [ *range_predicates(:amount),
      *range_predicates(:time),
      eq_predicate(:peer),
      eq_predicate(:issuer),
      like_predicate(:message)
    ].compact.inject { |l, r| l.and(r) }
  end

  def range_predicates name
    col = @params[:columns][name]
    [
      (@table[name].gteq(col[:lower]) if col[:lower]),
      (@table[name].lteq(col[:upper]) if col[:upper])
    ]
  end

  def eq_predicate name
    value = @params[:columns][name][:value]
    @table[name].eq(value) if value
  end

  def like_predicate name
    value = @params[:columns][name][:value]
    @table[name].matches("%#{value}%") if value
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

  def response_json(draw, selection)
    {
      draw: draw,
      recordsTotal: @user.transactions.count,
      recordsFiltered: selection.count,
      #data: selection.offset(params[:start]).take(params[:length]).map { |transaction| {
        #time: transaction.created_at,
        #amount: transaction.signed_amount_for(user),
        #peer: transaction.peer_of(user).try(:name),
        #issuer: transaction.issuer.name,
        #message: transaction.message,
      #}}
      data: selection
    }
  end
end

