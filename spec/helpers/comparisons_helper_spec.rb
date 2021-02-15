require 'rails_helper'

RSpec.describe ComparisonsHelper, type: :helper do
  describe '#active_product_module_categories' do
    context 'when product_modules is empty' do
      let(:product_modules) { [] }

      it 'returns an empty array' do
        expect(helper.active_product_module_categories(product_modules)).to match_array([])
      end
    end

    context 'when product_modules is not empty' do
      let(:product_modules) { [OpenStruct.new(category: 'core'), OpenStruct.new(category: 'wellness')] }

      it 'returns an array of categories where at least one product_module has that category' do
        expect(helper.active_product_module_categories(product_modules))
          .to match_array(%w[core wellness])
      end

      it 'does not include categories that are not included in at least one product_module' do
        expect(helper.active_product_module_categories(product_modules)).not_to include('outpatient')
      end
    end
  end

  describe '#coverage_icon' do
    context 'when the product module benefit is paid in full' do
      let(:product_module_benefit) { create(:product_module_benefit, benefit_status: 'paid_in_full') }
      let(:paid_in_full_icon) { 'fa fa-check icon--full-cover' }

      it 'returns the paid in full icon' do
        expect(helper.coverage_icon(product_module_benefit)).to eq paid_in_full_icon
      end
    end

    context 'when the product_module_benefit is a capped benefit' do
      let(:product_module_benefit) { create(:product_module_benefit, benefit_status: 'capped_benefit') }
      let(:capped_benefit_icon) { 'fa fa-circle-notch icon--capped-cover' }

      it 'returns the capped benefit icon' do
        expect(helper.coverage_icon(product_module_benefit)).to eq capped_benefit_icon
      end
    end

    context 'when the product_module_benefit is not covered' do
      let(:product_module_benefit) { NullProductModuleBenefit.new }
      let(:not_covered_icon) { 'fa fa-times icon--not-covered' }

      it 'returns the capped benefit icon' do
        expect(helper.coverage_icon(product_module_benefit)).to eq not_covered_icon
      end
    end
  end

  describe '#active_benefit_categories' do
    context 'with no benefits' do
      let(:benefits) { [] }

      it 'returns an empty array' do
        expect(helper.active_benefit_categories(benefits)).to match_array []
      end
    end

    context 'with benefits' do
      let(:benefits) do
        [
          OpenStruct.new(category: 'inpatient'),
          OpenStruct.new(category: 'evacuation_and_repatriation'),
          OpenStruct.new(category: 'wellness')
        ]
      end

      it 'returns a list of benefit categories where at least benefit has that category' do
        expect(helper.active_benefit_categories(benefits)).to match_array %w[inpatient evacuation_and_repatriation wellness]
      end
    end
  end

  describe 'benefits_grouped_by_category' do
    let(:benefits) { [inpatient_benefit, outpatient_benefit] }
    let(:inpatient_benefit) { create(:benefit) }
    let(:outpatient_benefit) { create(:benefit, category: 'outpatient') }

    it 'groups benefits by their category' do
      expect(helper.benefits_grouped_by_category(benefits))
        .to include({ 'inpatient' => [inpatient_benefit], 'outpatient' => [outpatient_benefit] })
    end
  end

  describe '#selected_core_module?' do
    let(:module_id) { 1 }

    context 'when the core module is nil' do
      let(:core_module) { nil }

      it 'returns false' do
        expect(helper.selected_core_module?(module_id, core_module)).to be false
      end
    end

    context 'when the module_id matched the id of the core module' do
      let(:core_module) { create(:product_module, id: 1) }

      it 'returns true' do
        expect(helper.selected_core_module?(module_id, core_module)).to be true
      end
    end

    context 'when the module id does not match the id of hte core module' do
      let(:core_module) { create(:product_module, id: 2) }

      it 'returns false' do
        expect(helper.selected_core_module?(module_id, core_module)).to be false
      end
    end
  end
end
