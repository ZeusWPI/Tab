class UserAbility
  include CanCan::Ability

  def initialize(user)
    return unless user

    can :manage, :all if user.penning?
    can :read,   user, id: user.id
    can :manage, Request,      creditor_id: user.id
    can :manage, Notification, user_id: user.id
    can :create, Transaction do |t|
      t.debtor == user && (t.debtor.balance - t.amount >= 0 || t.debtor.debt_allowed?)
    end
  end
end
