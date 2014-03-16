class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    can :read, [Course, Level, Question, Exam]

    if [1, 2].include? user.id
      can :access, :rails_admin
      can :dashboard
      can :manage, :all
    end
  end
end

