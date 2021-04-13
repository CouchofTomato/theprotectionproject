# frozen_string_literal: true

unless Rails.env.development?
  Rails.logger.info "[ db/seeds.rb ] Seed data is for development only, not #{Rails.env}"
  exit 0
end

require 'factory_bot'

# Clear existing data

Insurer.destroy_all
LinkedProductModule.destroy_all
ProductModuleBenefit.destroy_all
ProductModule.destroy_all
Product.destroy_all
User.destroy_all
Benefit.destroy_all

# Create dummy users for development
FactoryBot.create(:user, email: 'admin@email.com', password: 'admin123', admin: true)
FactoryBot.create(:user, email: 'user@email.com', password: 'user123')

# Create benefits for development
FactoryBot.create_list(:benefit, 10)
FactoryBot.create_list(:benefit, 10, category: 'outpatient')
FactoryBot.create_list(:benefit, 10, category: 'therapists')
FactoryBot.create_list(:benefit, 10, category: 'medicines_and_appliances')
FactoryBot.create_list(:benefit, 10, category: 'wellness')
FactoryBot.create_list(:benefit, 10, category: 'evacuation_and_repatriation')
FactoryBot.create_list(:benefit, 10, category: 'maternity')
FactoryBot.create_list(:benefit, 10, category: 'dental')
FactoryBot.create_list(:benefit, 10, category: 'optical')
FactoryBot.create_list(:benefit, 10, category: 'additional')

# Create insurers with individual plans
5.times do
  FactoryBot.create(:insurer) do |insurer|
    2.times do
      FactoryBot.create(:product, insurer: insurer) do |product|
        core_product_module = FactoryBot.create(:product_module, product: product)
        ProductModule.categories.keys.select{ _1 != 'core' }.each do |category|
          FactoryBot.create(:product_module, product: product, category: category) do |product_module|
            FactoryBot.create(:linked_product_module, product_module: core_product_module, linked_module: product_module)
            Benefit.all.sample(20).each_slice(2) do |benefit1, benefit2|
              FactoryBot.create(:product_module_benefit, product_module: product_module, benefit: benefit1)
              FactoryBot.create(:product_module_benefit,
                                benefit_status: 'capped_benefit',
                                product_module: product_module,
                                benefit: benefit2)
            end
          end
        end
      end
    end
  end
end

# Create insurers with corporate plans
5.times do
  FactoryBot.create(:insurer) do |insurer|
    2.times do
      FactoryBot.create(:product, customer_type: 'corporate', insurer: insurer) do |product|
        core_product_module = FactoryBot.create(:product_module, product: product)
        ProductModule.categories.keys.select{ _1 != 'core' }.each do |category|
          FactoryBot.create(:product_module, product: product, category: category) do |product_module|
            FactoryBot.create(:linked_product_module, product_module: core_product_module, linked_module: product_module)
            Benefit.all.sample(20).each_slice(2) do |benefit1, benefit2|
              FactoryBot.create(:product_module_benefit, product_module: product_module, benefit: benefit1)
              FactoryBot.create(:product_module_benefit,
                                benefit_status: 'capped_benefit',
                                product_module: product_module,
                                benefit: benefit2)
            end
          end
        end
      end
    end
  end
end
