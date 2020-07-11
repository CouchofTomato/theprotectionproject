require 'rails_helper'

RSpec.describe 'User Login and Logout', type: :system do
  before do
    create(:user, email: 'email@email.com', password: 'user123')
  end

  context 'when the user exists' do
    it 'can log in' do
      visit root_path
      click_on 'Login'

      fill_in 'user_email', with: 'email@email.com'
      fill_in 'user_password', with: 'user123'
      click_on 'Log in'

      expect(page).to have_content 'Signed in successfully.'
    end

    it 'can log out' do
      visit root_path
      click_on 'Login'

      fill_in 'user_email', with: 'email@email.com'
      fill_in 'user_password', with: 'user123'
      click_on 'Log in'

      click_on 'Logout'

      expect(page).to have_content 'Signed out successfully.'
    end
  end
end
