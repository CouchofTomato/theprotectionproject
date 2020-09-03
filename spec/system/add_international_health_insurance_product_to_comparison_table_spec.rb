require 'rails_helper'

RSpec.describe 'Add a plan to the comparison table', type: :system, js: true do
  before do
    insurer = create(:insurer, name: 'BUPA Global')
    product = create(:product, name: 'Lifeline', insurer: insurer)
    product_module = create(:product_module, name: 'Gold', product: product)
  end

  it 'adds selected product details to the comparison table' do
    user = create(:user)
    login_as(user, scope: :user)

    visit root_path
    click_on 'New Comparison'

    select 'BUPA Global', from: 'insurer-select'
    select 'Lifeline', from: 'product-select'
    page.choose('Gold')

    expect(page).to have_content 'Product successfully added'
  end
end
