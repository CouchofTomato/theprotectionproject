require 'rails_helper'

TestProductModule = Struct.new(:category)

RSpec.describe ComparisonsHelper, type: :helper do
  describe '#active_product_module_categories' do
    let(:categories) { %w[core outpatient wellness] }

    context 'when product_modules is empty' do
      let(:product_modules) { [] }

      it 'returns an empty array' do
        expect(helper.active_product_module_categories(categories, product_modules)).to match_array([])
      end
    end

    context 'when product_modules is not empty' do
      let(:product_modules) { [TestProductModule.new('core'), TestProductModule.new('wellness')] }

      it 'returns an array of categories where at least one product_module has that category' do
        expect(helper.active_product_module_categories(categories, product_modules))
          .to match_array(%w[core wellness])
      end

      it 'does not include categories that are not included in at least one product_module' do
        expect(helper.active_product_module_categories(categories, product_modules)).not_to include('outpatient')
      end
    end
  end

  describe('#coverage_icon') do
    context('when the product module benefit is paid in full') do
      let(:product_module_benefit) { create(:product_module_benefit, benefit_status: 'paid_in_full') }
      let(:paid_in_full_icon) { 'fa fa-check icon--full-cover' }

      it('returns the paid in full icon') do
        expect(helper.coverage_icon(product_module_benefit)).to eq paid_in_full_icon
      end
    end

    context('when the product_module_benefit is a capped benefit') do
      let(:product_module_benefit) { create(:product_module_benefit, benefit_status: 'capped_benefit') }
      let(:capped_benefit_icon) { 'fa fa-circle-notch icon--capped-cover' }

      it('returns the capped benefit icon') do
        expect(helper.coverage_icon(product_module_benefit)).to eq capped_benefit_icon
      end
    end

    context('when the product_module_benefit is not covered') do
      let(:product_module_benefit) { NullProductModuleBenefit.new }
      let(:not_covered_icon) { 'fa fa-times icon--not-covered' }

      it('returns the capped benefit icon') do
        expect(helper.coverage_icon(product_module_benefit)).to eq not_covered_icon
      end
    end
  end
end
