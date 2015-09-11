class ClientAbility
  include CanCan::Ability

  def initialize(client)
    client ||= Client.new # guest user (not logged in)
    can :manage, :all
  end
end
