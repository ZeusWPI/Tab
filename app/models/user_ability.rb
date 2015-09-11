class UserAbility
  include CanCan::Ability

  def initialize(user)
    return unless user

    can :manage, :all if user.penning?
    can :read, user, id: user.id
    can :create, Transaction, debtor: user
  end
end
