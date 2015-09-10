class TransactionsQuery
  def initialize user
    @user = user
    @transactions = Arel::Table.new(:transactions)
    @perspectived = Arel::Table.new(:perspectived_transactions)
    @peers = Arel::Table.new(:users).alias('peers')
  end

  def arel
    Arel::SelectManager.new(ActiveRecord::Base)
      .from(transactions)
      .join(@peers).on(@peers[:id].eq(@perspectived[:peer_id]))
      .project(
        @perspectived[:amount],
        @perspectived[:date],
        @peers[:name].as('peer'),
        @perspectived[:issuer_id],
        @perspectived[:message]
      )
  end

  def transactions
    Arel::Nodes::TableAlias.new(incoming.union(outgoing), @perspectived.name)
  end

  def outgoing
    @transactions
      .where(@transactions[:debtor_id].eq(@user.id))
      .project(
        (@transactions[:amount]*Arel::Nodes::SqlLiteral.new("-1")).as('amount'),
        @transactions[:creditor_id].as('peer_id'),
        @transactions[:created_at].as('date'),
        @transactions[:issuer_id],
        @transactions[:issuer_type],
        @transactions[:message]
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
        @transactions[:issuer_type],
        @transactions[:message]
      )
  end
end
