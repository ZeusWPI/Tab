class TransactionsGrid

  include Datagrid

  scope do
    Transaction
  end

  filter(:id, :integer)
  filter(:created_at, :date, range: true)

  column(:id)
  column(:amount)
  column(:created_at) do |model|
    model.created_at.to_date
  end
end
