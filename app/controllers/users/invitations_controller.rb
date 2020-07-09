# rubocop:disable Style/ClassAndModuleChildren
class Users::InvitationsController < Devise::InvitationsController
  def new
    if can? :invite, User
      super
    else
      redirect_to root_path
    end
  end
end
# rubocop:enable Style/ClassAndModuleChildren
