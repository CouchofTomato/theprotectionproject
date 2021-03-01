# frozen_string_literal: true

unless Rails.env.development?
  Rails.logger.info "[ db/seeds.rb ] Seed data is for development only, not #{Rails.env}"
  exit 0
end

require 'factory_bot'

# Clear existing data

LinkedProductModule.destroy_all
Insurer.destroy_all
ProductModuleBenefit.destroy_all
ProductModule.destroy_all
Product.destroy_all
User.destroy_all
Benefit.destroy_all
CoverageArea.destroy_all

# Create dummy users for development
FactoryBot.create(:user, email: 'admin@email.com', password: 'admin123', admin: true)
FactoryBot.create(:user, email: 'user@email.com', password: 'user123')
