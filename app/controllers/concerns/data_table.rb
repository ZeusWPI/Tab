class DataTable
  def initialize user, params
    @user = user
    @params = sanitize_params(params)
    @transactions = TransactionsQuery.new(@user)
    @table = @transactions.arel_table
  end

  def query
    @transactions.query
  end

  def predicates
  end

  def range_predicates name
    col = @params[:columns][name]
    [
      (@table[:name].gteq(col[:lower]) if col[:lower]),
      (@table[:name].lteq(col[:upper]) if col[:upper])
    ]
  end

  def json
    #if columns[:time][:lower]
      #query = query.where(table[:time].gteq(columns[:time][:lower]))
    #end

    #if columns[:time][:upper]
      #query = query.where(table



    # filter time
    #lower = params[:columns][:time][:lower]
    #upper = params[:columns][:time][:upper]
    #if lower and upper
      #selection = selection.where(created_at: lower..upper)
    #elsif lower
      #selection = selection.where('created_at > :lower', lower: lower)
    #elsif upper
      #selection = selection.where('created_at < :upper', upper: upper)
    #end

    ## filter amount TODO this filters on absolute value
    #lower = params[:columns][:amount][:lower]
    #upper = params[:columns][:amount][:upper]
    #if lower and upper
      #selection = selection.where(amount: lower..upper)
    #elsif lower
      #selection = selection.where('amount > :lower', lower: lower)
    #elsif upper
      #selection = selection.where('amount < :upper', upper: upper)
    #end

    ## filter peer # TODO peer.name
    #peer = params[:columns][:peer][:value]
    #if peer
      #selection = selection.where("(debtor_id = :id AND creditor_id LIKE :peer) OR (creditor_id = :id AND debtor_id LIKE :peer)", id: user.id, peer: "%#{peer}%")
    #end

    ## filter issuer # TODO issuer.name
    #issuer = params[:columns][:issuer][:value]
    #if issuer
      #selection = selection.where("issuer_id LIKE :re", re: "%#{issuer}%")
    #end

    ## filter message
    #message = params[:columns][:message][:value]
    #if message
      #selection = selection.where("message LIKE :re", re: "%#{message}%")
    #end

    ##selection_to_json(user, params[:draw], selection)

    #query = transactions.query

    selection = ActiveRecord::Base.connection.execute(query.to_sql).to_a
    response_json(@params[:draw], selection)
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

