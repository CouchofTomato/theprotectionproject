require 'rails_helper'

RSpec.describe 'New User Creation', type: :system do
  it 'can only be created by an admin using an invite' do
    user = create(:admin_user)
    login_as(user, scope: :user)

    visit root_path
    click_on 'Invite user'

    fill_in 'user_email', with: 'test@test.com'
    click_on 'Send an invitation'

    expect(page).to have_text 'An invitation email has been sent to test@test.com'
  end

  it 'does not allow non-admin users to create new accounts' do
    user = create(:user)
    login_as(user, scope: :user)

    visit new_user_invitation_path

    expect(page).to have_current_path(root_path)
  end
end
