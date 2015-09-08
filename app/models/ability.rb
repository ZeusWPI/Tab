class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.penning?
      can :manage, :all
    else
      can :read, user, id: user.id
    end
  end
end
