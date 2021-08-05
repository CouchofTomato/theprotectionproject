require 'rails_helper'

RSpec.describe SuitableHealthProductPolicy do
  let(:suitable_health_product_policy) { described_class.new(health_product, required_coverages).allowed? }
  let(:health_product) do
    ComparisonProduct.new(insurer: insurer, product: product, product_modules: product_modules)
  end
  let(:insurer) { create(:insurer) }
  let(:product) { create(:product, insurer: insurer) }

  describe('#allowed?') do
    context 'when the health_product does not have the required coverage areas' do
      let(:product_modules) { [core_module] }
      let(:core_module) do
        create(:product_module) do |product_module|
          create(:coverage_area, category: 'inpatient', product_module: product_module)
        end
      end
      let(:required_coverages) { %w[inpatient wellness] }

      it 'returns false' do
        expect(suitable_health_product_policy).to be false
      end
    end

    context 'when the health product does have the required coverage areas' do
      let(:product_modules) { [core_module] }
      let(:core_module) do
        create(:product_module) do |product_module|
          create(:coverage_area, category: 'inpatient', product_module: product_module)
          create(:coverage_area, category: 'wellness', product_module: product_module)
        end
      end
      let(:required_coverages) { %w[inpatient wellness] }

      it 'returns true' do
        expect(suitable_health_product_policy).to be true
      end
    end

    context 'when the health product has an outpatient coverage area' do
      let(:product_modules) { [core_module] }
      let(:core_module) do
        create(:product_module) do |product_module|
          create(:coverage_area, product_module: product_module)
          create(:coverage_area, category: 'outpatient', product_module: product_module)
        end
      end
      let(:required_coverages) { %w[inpatient outpatient] }

      it 'returns true when the required coverages includes outpatient' do
        expect(suitable_health_product_policy).to be true
      end
    end

    context 'when the health product has no outpatient coverage area' do
      let(:product_modules) { [core_module] }
      let(:core_module) do
        create(:product_module) do |product_module|
          create(:coverage_area, product_module: product_module)
        end
      end
      let(:required_coverages) { %w[inpatient outpatient] }

      it 'returns false when the required coverages does not include outpatient' do
        expect(suitable_health_product_policy).to be false
      end
    end
  end
end
