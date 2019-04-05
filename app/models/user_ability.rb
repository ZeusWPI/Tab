class UserAbility
  include CanCan::Ability

  def initialize(user)
    return unless user

    can :manage, :all if user.penning?
    can :create, Request, creditor_id: user.id
    can [:confirm, :decline], Request, debtor_id: user.id
    can [:read, :reset_key], User, id: user.id
    can :manage, Notification, user_id: user.id
    can :create, Transaction do |t|
      t.debtor == user && t.amount <= Rails.application.config.maximum_amount
    end
  end
end
