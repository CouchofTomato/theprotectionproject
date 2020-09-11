require 'rails_helper'

RSpec.describe ProductModuleBenefit, type: :model do
  subject(:product_module_benefit) { create(:product_module_benefit) }

  it { expect(product_module_benefit).to belong_to :product_module }
  it { expect(product_module_benefit).to belong_to :benefit }
  it { expect(product_module_benefit).to validate_presence_of :benefit_status }
  it { expect(product_module_benefit).to validate_presence_of :benefit_limit }
  it { expect(product_module_benefit).to validate_uniqueness_of(:product_module_id).scoped_to(:benefit_id) }
  it { expect(product_module_benefit).to define_enum_for(:benefit_status).with_values(['paid in full', 'capped benefit']) }

  describe('#full_benefit_coverage') do
    subject(:product_module_benefit) do
      create(:product_module_benefit, benefit_limit: 'paid in full', explanation_of_benefit: 'standard single room')
    end

    it('returns the benefit limit and explanation of benefit seperated by newlines') do
      expect(product_module_benefit.full_benefit_coverage).to eq "paid in full\n\nstandard single room"
    end
  end
end
