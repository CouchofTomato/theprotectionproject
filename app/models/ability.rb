# frozen_string_literal: true

# rubocop:disable Style/GuardClause
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin?
      can :invite, User
      can :access, :rails_admin
      can :read, :dashboard
    end
  end
end
# rubocop:enable Style/GuardClause
