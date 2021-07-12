require 'rails_helper'

CoverageAreaStruct = Struct.new(:category)

RSpec.describe MatchedCoverageComparisonProducts do
  subject(:matched_coverage_comparison_products) { described_class.new(required_coverages, comparison_products) }

  context 'with only inpatient coverage required' do
    let(:required_coverages) { %w[inpatient] }
    let(:comparison_products) { [comparison_product] }

    context 'with core modules that have inpatient coverage only' do
      let(:comparison_product) do
        instance_double(ComparisonProduct,
                        insurer: 'insurer',
                        product: 'product',
                        product_modules: [core_module_with_inpatient_cover],
                        coverage_areas?: true)
      end
      let!(:core_module_with_inpatient_cover) do
        instance_double(ProductModule,
                        category: 'core',
                        coverage_areas: [CoverageAreaStruct.new('inpatient')])
      end

      it 'includes those product modules' do
        expect(matched_coverage_comparison_products.match).to include(
          an_object_having_attributes(
            product_modules: a_collection_including(core_module_with_inpatient_cover)
          )
        )
      end
    end

    context 'with core modules with a linked outpatient module' do
      let(:comparison_product) do
        instance_double(ComparisonProduct,
                        insurer: 'insurer',
                        product: 'product',
                        product_modules: [core_module_with_inpatient_cover, linked_outpatient_module],
                        coverage_areas?: true)
      end
      let!(:core_module_with_inpatient_cover) do
        instance_double(ProductModule,
                        category: 'core',
                        coverage_areas: [CoverageAreaStruct.new('inpatient')])
      end
      let!(:linked_outpatient_module) do
        instance_double(ProductModule,
                        category: 'outpatient',
                        coverage_areas: [CoverageAreaStruct.new('outpatient')])
      end

      it 'does not include the outpatient module in the returned comparison product\'s product modules' do
        expect(matched_coverage_comparison_products.match).not_to include(
          an_object_having_attributes(
            product_modules: a_collection_including(linked_outpatient_module)
          )
        )
      end
    end

    context 'with core modules that have outpatient coverage' do
      let(:comparison_product) do
        instance_double(ComparisonProduct,
                        insurer: 'insurer',
                        product: 'product',
                        product_modules: [core_module_with_outpatient_cover],
                        coverage_areas?: true)
      end
      let!(:core_module_with_outpatient_cover) do
        instance_double(ProductModule,
                        category: 'core',
                        coverage_areas: [CoverageAreaStruct.new('inpatient'), CoverageAreaStruct.new('outpatient')])
      end

      it 'does not return comparison products that include those core modules' do
        expect(matched_coverage_comparison_products.match).not_to include(
          an_object_having_attributes(
            product_modules: a_collection_including(core_module_with_outpatient_cover)
          )
        )
      end
    end
  end

  context 'with outpatient coverage required' do
    let(:required_coverages) { %w[inpatient outpatient] }
    let(:comparison_products) { [comparison_product] }

    context 'with comparison products that include a product module with both inpatient and outpatient coverage' do
      let(:comparison_product) do
        instance_double(ComparisonProduct,
                        insurer: 'insurer',
                        product: 'product',
                        product_modules: [core_module_with_outpatient_cover],
                        coverage_areas?: true)
      end
      let!(:core_module_with_outpatient_cover) do
        instance_double(ProductModule,
                        category: 'core',
                        coverage_areas: [CoverageAreaStruct.new('inpatient'), CoverageAreaStruct.new('outpatient')])
      end

      it 'includes that comparison product in the returned list' do
        expect(matched_coverage_comparison_products.match).to include(
          an_object_having_attributes(
            product_modules: a_collection_including(core_module_with_outpatient_cover)
          )
        )
      end
    end

    context 'with comparison products with a product module with inpatient cover that has no linked outpatient module' do
      let(:comparison_product) do
        instance_double(ComparisonProduct,
                        insurer: 'insurer',
                        product: 'product',
                        product_modules: [core_module_with_inpatient_cover],
                        coverage_areas?: false)
      end
      let!(:core_module_with_inpatient_cover) do
        instance_double(ProductModule,
                        category: 'core',
                        coverage_areas: [CoverageAreaStruct.new('inpatient')])
      end

      it 'does not include that comparison product in the returned list' do
        expect(matched_coverage_comparison_products.match).not_to include(
          an_object_having_attributes(
            product_modules: a_collection_including(core_module_with_inpatient_cover)
          )
        )
      end
    end

    context 'with comparison products with a core product module with a link module with an outpatient coverage area' do
      let(:comparison_product) do
        instance_double(ComparisonProduct,
                        insurer: 'insurer',
                        product: 'product',
                        product_modules: [core_module_with_inpatient_cover, linked_outpatient_module],
                        coverage_areas?: true)
      end
      let!(:core_module_with_inpatient_cover) do
        instance_double(ProductModule,
                        category: 'core',
                        coverage_areas: [CoverageAreaStruct.new('inpatient')])
      end
      let!(:linked_outpatient_module) do
        instance_double(ProductModule,
                        category: 'outpatient',
                        coverage_areas: [CoverageAreaStruct.new('outpatient')])
      end

      it 'includes that comparison product in the returned list' do
        expect(matched_coverage_comparison_products.match).to include(
          an_object_having_attributes(
            product_modules: a_collection_including(linked_outpatient_module)
          )
        )
      end
    end
  end

  context 'with many required coverages' do
    let(:required_coverages) { %w[inpatient outpatient evacuation_and_repatriation dental] }
    let(:comparison_products) { [comparison_product] }

    context 'when covered under a single module' do
      let(:comparison_product) do
        instance_double(ComparisonProduct,
                        insurer: 'insurer',
                        product: 'product',
                        product_modules: [module_with_multiple_coverage_areas],
                        coverage_areas?: true)
      end
      let!(:module_with_multiple_coverage_areas) do
        instance_double(ProductModule,
                        category: 'core',
                        coverage_areas: [CoverageAreaStruct.new('inpatient'),
                                         CoverageAreaStruct.new('outpatient'),
                                         CoverageAreaStruct.new('evacuation_and_repatriation'),
                                         CoverageAreaStruct.new('dental')])
      end

      it 'selects a module that include those coverages' do
        expect(matched_coverage_comparison_products.match).to include(
          an_object_having_attributes(
            product_modules: a_collection_including(module_with_multiple_coverage_areas)
          )
        )
      end
    end

    # rubocop:disable RSpec/MultipleMemoizedHelpers
    context 'when covered under several modules' do
      let(:comparison_product) do
        instance_double(ComparisonProduct,
                        insurer: 'insurer',
                        product: 'product',
                        product_modules: [core_module, outpatient_module, evacuation_module, dental_module],
                        coverage_areas?: true)
      end
      let!(:core_module) do
        instance_double(ProductModule,
                        category: 'core',
                        coverage_areas: [CoverageAreaStruct.new('inpatient')])
      end
      let!(:outpatient_module) do
        instance_double(ProductModule,
                        category: 'outpatient',
                        coverage_areas: [CoverageAreaStruct.new('outpatient')])
      end
      let!(:evacuation_module) do
        instance_double(ProductModule,
                        category: 'evacuation_and_repatriation',
                        coverage_areas: [CoverageAreaStruct.new('evacuation_and_repatriation')])
      end
      let!(:dental_module) do
        instance_double(ProductModule,
                        category: 'dental',
                        coverage_areas: [CoverageAreaStruct.new('dental')])
      end

      it 'selects all the linked modules that include those coverages' do
        expect(matched_coverage_comparison_products.match).to include(
          an_object_having_attributes(
            product_modules: a_collection_including(core_module, outpatient_module, evacuation_module, dental_module)
          )
        )
      end
    end
    # rubocop:enable RSpec/MultipleMemoizedHelpers
  end

  context 'when a module has a coverage option which the user has not selected and is not outpatient' do
    let(:required_coverages) { %w[inpatient evacuation_and_repatriation] }
    let(:comparison_products) { [comparison_product] }

    context 'when under the core module' do
      let(:comparison_product) do
        instance_double(ComparisonProduct,
                        insurer: 'insurer',
                        product: 'product',
                        product_modules: [core_module],
                        coverage_areas?: true)
      end
      let!(:core_module) do
        instance_double(ProductModule,
                        category: 'core',
                        coverage_areas: [CoverageAreaStruct.new('inpatient'),
                                         CoverageAreaStruct.new('evacuation_and_repatriation')])
      end

      it 'includes the module' do
        expect(matched_coverage_comparison_products.match).to include(
          an_object_having_attributes(
            product_modules: a_collection_including(core_module)
          )
        )
      end
    end

    context 'when under a linked module' do
      let(:comparison_product) do
        instance_double(ComparisonProduct,
                        insurer: 'insurer',
                        product: 'product',
                        product_modules: [core_module, linked_module],
                        coverage_areas?: true)
      end
      let!(:core_module) do
        instance_double(ProductModule,
                        category: 'core',
                        coverage_areas: [CoverageAreaStruct.new('inpatient')])
      end
      let!(:linked_module) do
        instance_double(ProductModule,
                        category: 'evacuation_and_repatriation',
                        coverage_areas: [CoverageAreaStruct.new('wellness'),
                                         CoverageAreaStruct.new('evacuation_and_repatriation')])
      end

      it 'includes the linked module' do
        expect(matched_coverage_comparison_products.match).to include(
          an_object_having_attributes(
            product_modules: a_collection_including(core_module, linked_module)
          )
        )
      end
    end
  end
end
