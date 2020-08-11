class UserAbility
  include CanCan::Ability

  def initialize(user)
    return unless user

    can :manage, :all if user.penning?
    can :create, Request, creditor_id: user.id
    can :confirm, Request do |r|
      (r.debtor_id == user.id) && (user.balance - r.amount >= Rails.application.config.minimum_balance)
    end
    can :decline, Request, debtor_id: user.id
    can :cancel, Request, issuer_id: user.id
    can [:read, :reset_key, :add_registration_token], User, id: user.id
    can :manage, Notification, user_id: user.id
    can :create, Transaction do |t|
      t.debtor == user && t.amount <= Rails.application.config.maximum_amount && (user.balance - t.amount >= Rails.application.config.minimum_balance)
    end
  end
end
