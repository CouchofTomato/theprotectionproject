require 'rails_helper'

RSpec.describe 'navgiating to /admin', type: :system do
  it 'can be accessed by an admin user' do
    user = create(:admin_user)
    login_as(user, scope: :user)

    visit rails_admin_path
    expect(page).to have_current_path(rails_admin_path)
  end

  it 'cannot be acccessed by a non-admin user' do
    user = create(:user)
    login_as(user, scope: :user)

    visit rails_admin_path
    expect(page).to have_current_path(root_path)
  end
end
