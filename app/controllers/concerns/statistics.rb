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
    # Make a hash of all users and their debt
    #  only include them if their percentage is big enough
    debt_users = shameful_users.inject({}) do |h, u|
      h.merge({ u.name => -u.balance.to_f / total_debt * 100.0 })
    end.select { |user, debtpct| debtpct > 2 }

    # Sum of percentages that will be displayed
    total_displayed_debt_pct = debt_users.values.reduce(0) { |a, b| a + b }

    debt_users['Other users'] = 100 - total_displayed_debt_pct

    rounded_debts   = debt_users.transform_values(&:floor)
    rounded_deficit = 100 - rounded_debts.values.reduce(0) { |a, b| a + b }

    # Sort descending by amount after fraction of debt percentage
    #  then award users percentage points based on their ranking
    debt_users.sort_by { |k, v| -(v - v.floor) }
              .first(rounded_deficit)
              .each do |k|
      rounded_debts[k[0]] += 1
    end
    if (rounded_debts['Other users']).zero?
      rounded_debts.delete('Other users')
    end

    rounded_debts
  end

  def by_issuer
    Client.joins(:issued_transactions).group(:name).count.merge(
      { 'User created' => Transaction.where(issuer_type: 'User').count }
    )
  end

  def creation_counts
    User
      .joins(:issued_transactions)
      .group(:name)
      .order('count_all DESC')
      .count
      .take([shameful_users.count, 4].max)
  end
end
