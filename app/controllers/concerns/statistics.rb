class Statistics < Rails::Application
  def shameful_users
    User.humans
      .where('-balance > :amount', amount: config.shameful_balance)
      .order(:balance)
  end

  def total_debt
    -User.humans.where('balance < 0').sum(:balance)
  end

  def shamehash
    debt_users = shameful_users.inject({}) do |h, u|
      h.merge({u.name => - u.balance.to_f / total_debt * 100.0})
    end
    .select { |key, value| value > 2 }
    .transform_values! { |value| value.floor }

    total_displayed_debt_pct = debt_users.values.inject(0) {|a,b| a+b}

    debt_users["Other users"] = 100 - total_displayed_debt_pct
    debt_users
  end

  def by_issuer
    Client.joins(:issued_transactions).group(:name).count.merge({
      "User created" => Transaction.where(issuer_type: "User").count
    })
  end

  def creation_counts
    User
      .joins(:issued_transactions)
      .group(:name)
      .order("count_all DESC")
      .count
      .take([shameful_users.count, 4].max)
  end
end
