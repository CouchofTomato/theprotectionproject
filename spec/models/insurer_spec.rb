require 'rails_helper'

RSpec.describe Insurer, type: :model do
  subject(:insurer) { create(:insurer) }

  before { create(:insurer) }

  it { expect(insurer).to validate_presence_of :name }
  it { expect(insurer).to validate_uniqueness_of(:name).case_insensitive }
  it { expect(insurer).to have_many(:products).dependent(:destroy) }

  describe 'products_with_customer_type' do
    before do
      create(:insurer, :with_individual_product, name: 'BUPA Global')
      create(:insurer, :with_corporate_product, name: 'Allianz')
    end

    it 'returns only insurers that have products for the provided customer type' do
      expect(described_class.offers_products_with_customer_type('individual')).to match(
        a_collection_including(an_object_having_attributes(name: 'BUPA Global'))
      )
    end
  end
end
