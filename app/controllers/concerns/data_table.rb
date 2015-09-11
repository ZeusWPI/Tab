class DataTable

  def initialize user, params
    @user = user
    @params = sanitize_params(params)
    @transactions = TransactionsQuery.new(@user)
    @table = @transactions.arel_table
  end

  def json
    {
      draw: @params[:draw],
      recordsTotal: @user.transactions.count,
      recordsFiltered: count,
      data: data
    }
  end

  private

  def data
    run_query(paginated_query.project(Arel.star))
  end

  def count
    run_query(query.project(Arel.star.count)).first[0]
  end

  def paginated_query
    query.skip(@params[:start]).take(@params[:length])
  end

  def query
    return @query if @query # Do not build query twice
    @query = @transactions.query
    @query.where(predicate) if predicate
    @query
  end

  def predicate
    @predicate ||= [
      *range_predicates(:amount),
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

  def run_query query
    ActiveRecord::Base.connection.execute(query.to_sql)
  end

  def sanitize_params(params)
    # Parsing according to https://datatables.net/manual/server-side
    clean = {
      draw: params.require(:draw).to_i,
      start: params.require(:start).to_i,
      length: params.require(:length).to_i,
      columns: Hash.new
    }
    params.require(:columns).each do |i, column|
      type, *values = column.require(:search)[:value].split(':')
      value = values.join(':') unless values.empty?
      h = clean[:columns][column.require(:data).to_sym] = {
        name: column[:name],
        searchable: column[:searchable] == 'true',
        orderable: column[:orderable] == 'true',
        type: type
      }
      if type == 'number-range'
        h[:lower], h[:upper] = value.split('~').map do |euros|
          (euros.to_f * 100).to_i rescue nil
        end
      elsif type == 'date-range'
        h[:lower], h[:upper] = value.split('~').map do |string|
          string.to_datetime rescue nil
        end
      else
        h[:value] = value
      end
    end
    return clean
  end
end

