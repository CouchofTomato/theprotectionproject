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
end
