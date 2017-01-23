class ClientAbility
  include CanCan::Ability

  def initialize(client)
    client ||= Client.new # guest user (not logged in)

    can :create, Transaction if client.has_role? :create_transactions
    can :create, Request
    can :read, User
  end
end
