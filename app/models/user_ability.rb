class UserAbility
  include CanCan::Ability

  def initialize(user)
    return unless user

    can :manage, :all if user.penning?
    can :read,   user, id: user.id
    can :manage, Request, user_id: user.id
    can :create, Transaction do |t|
      t.debtor == user && t.amount <= Rails.application.config.maximum_amount
    end
  end
end
