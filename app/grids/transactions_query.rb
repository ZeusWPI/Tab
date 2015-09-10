class TransactionsQuery
  def initialize user
    @user = user
    @transactions = Arel::Table.new(:transactions)
  end

  def arel
    Arel::SelectManager.new(ActiveRecord::Base)
      .from(transactions)
      .project(
        @transactions[:amount],
        @transactions[:date],
        @transactions[:peer_id],
        @transactions[:issuer_id],
        @transactions[:message]
      )
  end

  def transactions
    Arel::Nodes::UnionAll.new(outgoing, incoming)
  end

  def outgoing
    @transactions
      .where(@transactions[:debtor_id].eq(@user.id))
      .project(
        (@transactions[:amount]*Arel::Nodes::SqlLiteral.new("-1")).as('amount'),
        @transactions[:creditor_id].as('peer_id'),
        @transactions[:created_at].as('date'),
        @transactions[:issuer_id],
        @transactions[:issuer_type]
      )
  end

  def incoming
    @user.incoming_transactions.arel
    @transactions
      .where(@transactions[:debtor_id].eq(@user.id))
      .project(
        @transactions[:amount],
        @transactions[:debtor_id].as('peer_id'),
        @transactions[:created_at].as('date'),
        @transactions[:issuer_id],
        @transactions[:issuer_type]
      )
  end
end
