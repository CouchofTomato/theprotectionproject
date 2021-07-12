require 'rails_helper'

RSpec.describe Product, type: :model do
  subject(:product) { create(:product) }

  before { create(:product, name: 'BUPA') }

  it { expect(product).to belong_to :insurer }
  it { expect(product).to validate_presence_of :name }
  it { expect(product).to validate_uniqueness_of(:name).case_insensitive }
  it { expect(product).to validate_presence_of :insurer }
  it { expect(product).to have_many(:product_modules).dependent(:destroy) }
  it { expect(product).to define_enum_for(:customer_type).with_values(%w[individual corporate]) }

  describe('#core_modules') do
    subject(:product)  do
      create(:product) do |product|
        create_list(:product_module, 3, product: product)
        create_list(:product_module, 2, category: 'outpatient', product: product)
      end
    end

    it('returns those product_modules with a core category that belong to the product') do
      expect(
        product.core_modules.all? { |product_module| product_module.category == 'core' }
      ).to be true
    end

    it('does not select product_modules which do not have a core category') do
      expect(
        product.core_modules.none? { |product_module| product_module.category != 'core' }
      ).to be true
    end
  end

  describe '.individual_products' do
    let(:individual_product) { create(:product, customer_type: 'individual') }
    let(:corporate_product) { create(:product, customer_type: 'corporate') }

    it 'returns a list of products with an individual customer type' do
      expect(described_class.individual_products).to include individual_product
    end

    it 'does not include any products with a corporate customer type' do
      expect(described_class.individual_products).not_to include corporate_product
    end
  end
end
