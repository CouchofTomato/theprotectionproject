require 'rails_helper'

RSpec.describe 'New User Creation', type: :system do
  it 'can only be created by an admin using an invite' do
    user = create(:admin_user)
    login_as(user, scope: :user)

    visit new_user_invitation_path
    click_on 'create new user'

    fill_in 'email', with: 'test@test.com'
    click_on 'invite'

    expect(page).to have_text 'invite sent!'
  end
end
