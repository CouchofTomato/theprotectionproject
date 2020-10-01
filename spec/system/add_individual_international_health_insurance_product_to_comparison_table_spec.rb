require 'rails_helper'

RSpec.describe 'Add an individual plan to the comparison table', type: :system, js: true do
  before do
    create(:insurer, name: 'BUPA Global') do |insurer|
      create(:product, name: 'Lifeline', insurer: insurer) do |product|
        create(:product_module, name: 'Gold', product: product) do |product_module|
          create_list(:product_module_benefit, 3, product_module: product_module)
          create_list(:product_module_benefit, 2, benefit_status: 'capped benefit', product_module: product_module)
        end
      end
      create(:product, name: 'Company', customer_type: 'corporate', insurer: insurer)
    end
    create(:insurer, name: 'Allianz') do |insurer|
      create(:product, name: 'International Health', customer_type: 'corporate', insurer: insurer) do |product|
        create(:product_module, name: 'Core Pro', product: product) do |product_module|
          create_list(:product_module_benefit, 3, product_module: product_module)
          create_list(:product_module_benefit, 2, benefit_status: 'capped benefit', product_module: product_module)
        end
      end
    end
    user = create :user
    login_as user, scope: :user
  end

  it 'shows insurers and their individual products and adds selected plan details to the comparison table' do
    visit root_path
    click_on 'New Individual Comparison'

    find('#insurer-select')
    expect(page).not_to have_select('insurer-select', with_options: ['Allianz'])

    expect(page).not_to have_select('product-select', with_options: ['Company'])

    select 'BUPA Global', from: 'insurer-select'
    select 'Lifeline', from: 'product-select'
    page.choose 'Gold'
    click_button 'Load Benefits'

    expect(find('tr[data-target="comparison-product.insurerTableRow"] > td:nth-of-type(1)')).to have_content 'BUPA Global'
    expect(find('tr[data-target="comparison-product.productTableRow"] > td:nth-of-type(1)')).to have_content 'Lifeline'
    expect(find('tr[data-target="comparison-product.chosenCoverRow"] > td:nth-of-type(1)')).to have_content 'Gold'
    expect(find('tr[data-target="comparison-product.overallSumAssured"] > td:nth-of-type(1)'))
      .to have_content 'USD 3,000,000 | EUR 3,200,000 | GBP 2,500,000'
    expect(page).to have_css('i.icon--full-cover', count: 3)
    expect(page).to have_css('i.icon--capped-cover', count: 2)
    expect(page).to have_css('i.icon--not-covered', count: 5)
  end
end
