require 'rails_helper'

RSpec.describe 'Add a corporate plan to the comparison table', type: :system, js: true do
  before do
    create(:insurer, name: 'BUPA Global') do |insurer|
      create(:product, name: 'Lifeline', customer_type: 'corporate', insurer: insurer) do |product|
        create(:product_module, name: 'Gold', product: product) do |product_module|
          create_list(:product_module_benefit, 3, product_module: product_module)
          create_list(:product_module_benefit, 2, benefit_status: 'capped_benefit', product_module: product_module)
        end
        create(:product_module, name: 'Evacuation',
                                product: product,
                                category: 'evacuation_and_repatriation') do |product_module|
          create_list(:product_module_benefit, 2, product_module: product_module)
          create(:linked_product_module, product_module: ProductModule.find_by(name: 'Gold'), linked_module: product_module)
        end
      end
      create(:product, name: 'Company', insurer: insurer)
    end
    create(:insurer, name: 'Allianz') do |insurer|
      create(:product, name: 'International Health', customer_type: 'individual', insurer: insurer) do |product|
        create(:product_module, name: 'Core Pro', product: product) do |product_module|
          create_list(:product_module_benefit, 3, product_module: product_module)
          create_list(:product_module_benefit, 2, benefit_status: 'capped_benefit', product_module: product_module)
        end
      end
    end
    user = create :user
    login_as user, scope: :user
  end

  it 'shows insurers and their corporate products and adds selected plan details to the comparison table' do
    visit root_path
    find(:test_id, 'user-navbar-dropdown').hover
    click_on 'New Corporate Comparison'

    find('#insurer-select')
    expect(page).not_to have_select('insurer-select', with_options: ['Allianz'])

    select 'BUPA Global', from: 'insurer-select'

    expect(page).not_to have_select('product-select', with_options: ['Company'])

    select 'Lifeline', from: 'product-select'

    expect(page).to have_selector('h5', text: 'Core')
    expect(page).not_to have_selector('h5', text: 'Evacuation And Repatriation')

    page.choose 'Gold'

    expect(page).to have_selector('h5', text: 'Evacuation And Repatriation')

    click_button 'Load Benefits'

    expect(find('tr#insurer-name > td:nth-of-type(1)')).to have_content 'BUPA Global'
    expect(find('tr#product-name > td:nth-of-type(1)')).to have_content 'Lifeline'
    expect(find('tr#chosen-cover > td:nth-of-type(1)')).to have_content 'Gold'
    expect(find('tr#overall-sum-assured > td:nth-of-type(1)'))
      .to have_content 'USD 3,000,000 | EUR 3,200,000 | GBP 2,500,000'
    expect(page).to have_css('i.icon--full-cover', count: 3)
    expect(page).to have_css('i.icon--capped-cover', count: 2)
    expect(page).to have_css('i.icon--not-covered', count: 7)
  end
end
