
module DataTable
  extend ActiveSupport::Concern

  def apply_filter(user, params)
    p selection_to_json(user, user.transactions)
    selection_to_json(user, user.transactions)
  end

  private

  def selection_to_json(user, selection)
    { data: selection.map { |transaction| {
        amount: transaction.signed_amount_for(user),
        origin: transaction.origin,
        message: transaction.message,
        peer: transaction.peer_of(user).try(:name),
        time: transaction.created_at
      } }
    }
  end
end

