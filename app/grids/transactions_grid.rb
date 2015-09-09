class TransactionsGrid

  include Datagrid

  attr_accessor :current_user

  scope do
    Transaction
    #@current_user.transactions
    # TODO current user should not be nil
  end

  self.default_column_options = { order: false }

  column(:created_at, order: true) { |model| model.created_at.to_date }
  filter(:created_at, :date, range: true)

  column(:amount)
  filter(:amount, :integer, range: true)

  column(:peer) { |model| model.peer_of(@current_user).try(:name) }
  #filter(:peer) { |value| where(
  # TODO extensive?

  column(:issuer) { |model| model.issuer.name }
  #filter(:issuer) { |value| where("issuer.name LIKE :value", value: "%#{value}%") }
  # TODO issuer.name needs join

  column(:message)
  filter(:message) { |value| where("message LIKE :value", value: "%#{value}%") }

end
