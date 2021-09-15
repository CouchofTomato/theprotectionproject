require 'rails_helper'

RSpec.describe SuitableHealthProducts do
  subject(:suitable_health_products) do
    described_class.new(comparison_products, applicants, required_coverages)
  end

  let(:comparison_products) { [comparison_product] }
  let(:comparison_product) do
    ComparisonProduct.new(insurer: insurer, product: product, product_modules: product_modules)
  end
  let(:insurer) { create(:insurer) }
  let(:product) { create(:product, insurer: insurer) }
  let(:applicants) do
    [
      ServiceModels::Applicant.new(name: 'Main Applicant',
                                   date_of_birth: 40.years.ago,
                                   relationship: 'self',
                                   nationality: 'British',
                                   country_of_residence: 'United Kingdom'),
      ServiceModels::Applicant.new(name: 'Dependant',
                                   date_of_birth: 39.years.ago,
                                   relationship: 'spouse',
                                   nationality: 'British',
                                   country_of_residence: 'United Kingdom')
    ]
  end

  context 'with only inpatient coverage required' do
    let(:required_coverages) { %w[inpatient] }

    context 'with core modules that have inpatient coverage only' do
      let(:product_modules) { [core_module_with_inpatient_cover] }
      let!(:core_module_with_inpatient_cover) do
        create(:product_module, product: product) do |product_module|
          create(:coverage_area, category: 'inpatient', product_module: product_module)
        end
      end

      it 'includes comparison products that include those product modules' do
        expect(suitable_health_products.match).to include(
          an_object_having_attributes(
            product_modules: a_collection_including(core_module_with_inpatient_cover)
          )
        )
      end
    end

    context 'with core modules with a linked outpatient module' do
      let(:product_modules) { [core_module_with_inpatient_cover, linked_outpatient_module] }
      let(:core_module_with_inpatient_cover) do
        create(:product_module) do |product_module|
          create(:coverage_area, category: 'inpatient', product_module: product_module)
        end
      end
      let(:linked_outpatient_module) do
        create(:product_module, category: 'outpatient', product: product) do |product_module|
          create(:coverage_area, category: 'outpatient', product_module: product_module)
          create(:linked_product_module, product_module: core_module_with_inpatient_cover, linked_module: product_module)
        end
      end

      it 'does not include the outpatient module in the returned comparison product\'s product modules' do
        expect(suitable_health_products.match).not_to include(
          an_object_having_attributes(
            product_modules: a_collection_including(linked_outpatient_module)
          )
        )
      end
    end

    context 'with core modules that have outpatient coverage' do
      let(:product_modules) { [core_module_with_outpatient_cover] }
      let(:core_module_with_outpatient_cover) do
        create(:product_module) do |product_module|
          create(:coverage_area, category: 'inpatient', product_module: product_module)
          create(:coverage_area, category: 'outpatient', product_module: product_module)
        end
      end

      it 'does not return comparison products that include those core modules' do
        expect(suitable_health_products.match).not_to include(
          an_object_having_attributes(
            product_modules: a_collection_including(core_module_with_outpatient_cover)
          )
        )
      end
    end
  end

  context 'with outpatient coverage required' do
    let(:required_coverages) { %w[inpatient outpatient] }

    context 'with comparison products that include a product module with both inpatient and outpatient coverage' do
      let(:product_modules) { [core_module_with_outpatient_cover] }
      let(:core_module_with_outpatient_cover) do
        create(:product_module) do |product_module|
          create(:coverage_area, category: 'inpatient', product_module: product_module)
          create(:coverage_area, category: 'outpatient', product_module: product_module)
        end
      end

      it 'includes that comparison product in the returned list' do
        expect(suitable_health_products.match).to include(
          an_object_having_attributes(
            product_modules: a_collection_including(core_module_with_outpatient_cover)
          )
        )
      end
    end

    context 'with comparison products with a product module with inpatient cover that has no linked outpatient module' do
      let(:product_modules) { [core_module_with_inpatient_cover] }
      let!(:core_module_with_inpatient_cover) do
        create(:product_module, product: product) do |product_module|
          create(:coverage_area, category: 'inpatient', product_module: product_module)
        end
      end

      it 'does not include that comparison product in the returned list' do
        expect(suitable_health_products.match).not_to include(
          an_object_having_attributes(
            product_modules: a_collection_including(core_module_with_inpatient_cover)
          )
        )
      end
    end

    context 'with comparison products with a core product module with a link module with an outpatient coverage area' do
      let(:product_modules) { [core_module_with_inpatient_cover, linked_outpatient_module] }
      let(:core_module_with_inpatient_cover) do
        create(:product_module) do |product_module|
          create(:coverage_area, category: 'inpatient', product_module: product_module)
        end
      end
      let(:linked_outpatient_module) do
        create(:product_module, category: 'outpatient', product: product) do |product_module|
          create(:coverage_area, category: 'outpatient', product_module: product_module)
          create(:linked_product_module, product_module: core_module_with_inpatient_cover, linked_module: product_module)
        end
      end

      it 'includes that comparison product in the returned list' do
        expect(suitable_health_products.match).to include(
          an_object_having_attributes(
            product_modules: a_collection_including(linked_outpatient_module)
          )
        )
      end
    end
  end

  context 'with many required coverages' do
    let(:required_coverages) { %w[inpatient outpatient evacuation dental] }

    context 'when covered under a single module' do
      let(:product_modules) { [module_with_multiple_coverage_areas] }
      let(:module_with_multiple_coverage_areas) do
        create(:product_module) do |product_module|
          create(:coverage_area, category: 'inpatient', product_module: product_module)
          create(:coverage_area, category: 'outpatient', product_module: product_module)
          create(:coverage_area, category: 'evacuation', product_module: product_module)
          create(:coverage_area, category: 'dental', product_module: product_module)
        end
      end

      it 'selects a module that include those coverages' do
        expect(suitable_health_products.match).to include(
          an_object_having_attributes(
            product_modules: a_collection_including(module_with_multiple_coverage_areas)
          )
        )
      end
    end

    context 'when covered under several modules' do
      let(:product_modules) { [core_module, outpatient_module, evacuation_module, dental_module] }
      let!(:core_module) do
        create(:product_module, product: product) do |product_module|
          create(:coverage_area, category: 'inpatient', product_module: product_module)
        end
      end
      let!(:outpatient_module) do
        create(:product_module, category: 'outpatient', product: product) do |product_module|
          create(:coverage_area, category: 'outpatient', product_module: product_module)
        end
      end
      let!(:evacuation_module) do
        create(:product_module, category: 'evacuation_and_repatriation', product: product) do |product_module|
          create(:coverage_area, category: 'evacuation', product_module: product_module)
        end
      end
      let!(:dental_module) do
        create(:product_module, category: 'dental_and_optical', product: product) do |product_module|
          create(:coverage_area, category: 'dental', product_module: product_module)
        end
      end

      it 'selects all the linked modules that include those coverages' do
        expect(suitable_health_products.match).to include(
          an_object_having_attributes(
            product_modules: a_collection_including(core_module, outpatient_module, evacuation_module, dental_module)
          )
        )
      end
    end
  end

  context 'when a module has a coverage option which the user has not selected and is not outpatient' do
    let(:required_coverages) { %w[inpatient evacuation] }

    context 'when under the core module' do
      let(:product_modules) { [core_module] }
      let(:core_module) do
        create(:product_module) do |product_module|
          create(:coverage_area, category: 'inpatient', product_module: product_module)
          create(:coverage_area, category: 'evacuation', product_module: product_module)
        end
      end

      it 'includes the module' do
        expect(suitable_health_products.match).to include(
          an_object_having_attributes(
            product_modules: a_collection_including(core_module)
          )
        )
      end
    end

    context 'when under a linked module' do
      let(:product_modules) { [core_module, evacuation_module] }
      let!(:core_module) do
        create(:product_module, product: product) do |product_module|
          create(:coverage_area, category: 'inpatient', product_module: product_module)
        end
      end
      let!(:evacuation_module) do
        create(:product_module, category: 'evacuation_and_repatriation', product: product) do |product_module|
          create(:coverage_area, category: 'evacuation', product_module: product_module)
        end
      end

      it 'includes the linked module' do
        expect(suitable_health_products.match).to include(
          an_object_having_attributes(
            product_modules: a_collection_including(core_module, evacuation_module)
          )
        )
      end
    end
  end
end
