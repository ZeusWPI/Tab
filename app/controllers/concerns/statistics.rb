
class Statistics < Rails::Application

  def shameful_users
    User.where('balance > :amount', amount: config.shameful_balance)
        .order(balance: :desc)
  end

  def total_debt
    User.where.not(id: User.zeus).where('balance > 0').sum(:balance)
  end

  def shamehash
    none_shaming = shameful_users.sum(:balance)
    shameful_users.inject({'None-shameful users' => none_shaming}) do |h, u|
      h.merge({u.name => u.balance})
    end
  end

  private

  def zeus_balance
    User.zeus.balance
  end

end
