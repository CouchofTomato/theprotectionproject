require 'rails_helper'

RSpec.describe 'Add a plan to the comparison table', type: :system do
  it 'adds selected product details to the comparison table' do
    user = create(:user)
    login_as(user, scope: :user)

    visit root_path
    click_on 'New Comparison'

    select 'BUPA Global', from: 'insurer'
    select 'Lifeline', from: 'product'
    select 'Gold', from: 'productModule'

    expect(page).to have_content 'Product successfully added'
  end
end
