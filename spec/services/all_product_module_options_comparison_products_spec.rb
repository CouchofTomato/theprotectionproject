require 'rails_helper'

RSpec.describe AllProductModuleOptionsComparisonProducts do
  subject(:all_product_module_options_comparison_products) { described_class }

  let!(:insurer) { create(:insurer) }
  let!(:product) { create(:product, insurer: insurer) }

  describe '.call' do
    context 'when a product has linked modules all with different categories' do
      let!(:product_module) { create(:product_module, product: product) }
      let!(:linked_outpatient_module) do
        create(:product_module, category: :outpatient, product: product) do |linked_outpatient_module|
          create(:linked_product_module, product_module: product_module, linked_module: linked_outpatient_module)
        end
      end
      let!(:linked_wellness_module) do
        create(:product_module, category: :wellness, product: product) do |linked_wellness_module|
          create(:linked_product_module, product_module: product_module, linked_module: linked_wellness_module)
        end
      end

      it 'returns a list that includes a comparison product with those product modules' do
        expect(all_product_module_options_comparison_products.call).to include(
          an_object_having_attributes(
            product_modules: a_collection_including(product_module, linked_outpatient_module, linked_wellness_module)
          )
        )
      end
    end

    context 'when a core product module has more than one linked module with the same category' do
      let!(:product_module) { create(:product_module, product: product) }
      let!(:first_linked_outpatient_module) do
        create(:product_module, category: :outpatient, product: product) do |first_linked_outpatient_module|
          create(:linked_product_module, product_module: product_module, linked_module: first_linked_outpatient_module)
        end
      end
      let!(:second_linked_outpatient_module) do
        create(:product_module, category: :outpatient, product: product) do |second_linked_outpatient_module|
          create(:linked_product_module, product_module: product_module, linked_module: second_linked_outpatient_module)
        end
      end

      it 'creates separate comparison products for those linked modules' do
        expect(all_product_module_options_comparison_products.call).to include(
          an_object_having_attributes(
            product_modules: a_collection_including(product_module, first_linked_outpatient_module)
          ),
          an_object_having_attributes(
            product_modules: a_collection_including(product_module, second_linked_outpatient_module)
          )
        )
      end

      it 'does not add both linked modules to the same comparison product' do
        expect(all_product_module_options_comparison_products.call).not_to include(
          an_object_having_attributes(
            product_modules: a_collection_including(product_module,
                                                    first_linked_outpatient_module,
                                                    second_linked_outpatient_module)
          )
        )
      end
    end

    context 'with an individual customer' do
      let!(:product) { create(:product, customer_type: 'corporate', insurer: insurer) }
      let!(:product_module) { create(:product_module, product: product) }

      it 'does not show plans that are for corporate customers' do
        expect(all_product_module_options_comparison_products.call).not_to include(
          an_object_having_attributes(
            product_modules: a_collection_including(product_module)
          )
        )
      end
    end

    context 'with the product modules within the comparison product' do
      let!(:product_module) { create(:product_module, product: product) }
      let!(:linked_outpatient_module) do
        create(:product_module, category: :outpatient, product: product) do |linked_outpatient_module|
          create(:linked_product_module, product_module: product_module, linked_module: linked_outpatient_module)
        end
      end

      it 'must not generate a comparison product without a core module' do
        expect(all_product_module_options_comparison_products.call).not_to include(
          an_object_having_attributes(
            product_modules: [linked_outpatient_module]
          )
        )
      end
    end
  end
end
