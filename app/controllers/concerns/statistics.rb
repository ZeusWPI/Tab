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
    none_shaming = total_debt + shameful_users.sum(:balance)
    shameful_users.inject({'Reputable users' => none_shaming.to_f / total_debt}) do |h, u|
      h.merge({u.name => - u.balance.to_f / total_debt})
    end
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

