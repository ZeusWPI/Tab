
class Statistics < Rails::Application

  def shameful_users
    User.where('balance > :amount', amount: config.shameful_balance)
        .order(:balance)
  end

  private

  def zeus_balance
    User.zeus.balance
  end

end
