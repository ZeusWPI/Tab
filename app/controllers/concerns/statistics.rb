
class Statistics < Rails::Application

  def shameful_users
    User.where('balance > :amount', amount: config.shameful_balance)
        .order(balance: :desc)
  end

  def total_debt
    User.where.not(id: User.zeus).where('balance > 0').sum(:balance)
  end

  private

  def zeus_balance
    User.zeus.balance
  end

end
