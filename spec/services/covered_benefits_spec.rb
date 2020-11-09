require 'rails_helper'

RSpec.describe CoveredBenefits do
  subject(:covered_benefits) { described_class }

  let(:comparison_products) { [comparison_product] }
  let(:comparison_product) { instance_double 'ComparisonProduct' }
  let(:module_benefits) { [module_benefit] }
  let(:module_benefit) { instance_double 'ProductModuleBenefit', benefit_id: 1 }
  let(:options) { [:covered_benefits] }

  before do
    create_list(:benefit, 5)
  end

  describe '.all' do
    context 'with no options' do
      it 'returns all benefits' do
        expect(covered_benefits.all(comparison_products)).to eq Benefit.all
      end
    end

    context 'with the covered_benefits options' do
      it 'returns the benefits covered under the ComparisonProducts benefits' do
        allow(comparison_product).to receive(:module_benefits).and_return(module_benefits)
        expect(covered_benefits.all(comparison_products, options)).to eq Benefit.where(id: [1])
      end
    end
  end
end
