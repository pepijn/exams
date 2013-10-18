class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    if [1, 2].include? user.id
      can :access, :rails_admin
      can :dashboard
    end
  end
end

