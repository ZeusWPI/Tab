class TransactionsGrid

  include Datagrid

  attr_accessor :current_user

  scope do
    Transaction
    #@current_user.transactions
    # TODO how to get current user here?
  end

  self.default_column_options = { order: false }

  column(:created_at, order: true) { |model| model.created_at.to_date }
  filter(:created_at, :date, range: true)

  column(:amount)
  filter(:amount, :integer, range: true)

  column(:peer) { |model, scope, grid| model.peer_of(grid.current_user).try(:name) }
  filter(:peer, :string, header: 'Peer') do |value, scope, grid|
    scope.joins(debtor: 'id', creditor: 'id')
      .where("(debtor_id = :user AND creditor.name LIKE :name) OR (creditor_id = :user AND debtor.name LIKE :name)", user: grid.current_user.id, name: "%#{value}%")
  end
  # TODO this should probably by a SQL statement

  column(:issuer) { |model| model.issuer.name }
  filter(:issuer, :string, header: 'Issuer') do |value|
    self.joins(:issuer).where("issuer.name LIKE :value", value: "%#{value}%")
  end

  column(:message)
  filter(:message) { |value| where("message LIKE :value", value: "%#{value}%") }

end
