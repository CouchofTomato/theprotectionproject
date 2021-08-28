require 'rails_helper'

RSpec.describe SuitableHealthProductPolicy do
  subject(:suitable_health_product_policy) { described_class.new(required_coverages, applicants) }

  let(:required_coverages) { %w[inpatient] }
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
  let(:health_product) do
    ComparisonProduct.new(insurer: insurer, product: product, product_modules: product_modules)
  end
  let(:insurer) { create(:insurer) }
  let(:product) { create(:product, minimum_applicant_age: 18, maximum_applicant_age: 80, insurer: insurer) }
  let(:product_modules) { [core_module] }
  let(:core_module) do
    create(:product_module) do |product_module|
      create(:coverage_area, product_module: product_module)
    end
  end

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
        expect(suitable_health_product_policy.allowed?(health_product)).to be false
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
        expect(suitable_health_product_policy.allowed?(health_product)).to be true
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
        expect(suitable_health_product_policy.allowed?(health_product)).to be true
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
        expect(suitable_health_product_policy.allowed?(health_product)).to be false
      end
    end

    context 'when the main applicnats age is between the health products minimum and maximum age' do
      it 'returns true' do
        expect(suitable_health_product_policy.allowed?(health_product)).to be true
      end
    end

    context 'when the main applicants age is less than the health products minimum age' do
      let(:applicants) do
        [
          ServiceModels::Applicant.new(name: 'Main Applicant',
                                       date_of_birth: 17.years.ago,
                                       relationship: 'self',
                                       nationality: 'British',
                                       country_of_residence: 'United Kingdom')
        ]
      end

      it 'returns false' do
        expect(suitable_health_product_policy.allowed?(health_product)).to be false
      end
    end

    context 'when the main applicants age is greater than the health products maximum age' do
      let(:applicants) do
        [
          ServiceModels::Applicant.new(name: 'Main Applicant',
                                       date_of_birth: 81.years.ago,
                                       relationship: 'self',
                                       nationality: 'British',
                                       country_of_residence: 'United Kingdom')
        ]
      end

      it 'returns false' do
        expect(suitable_health_product_policy.allowed?(health_product)).to be false
      end
    end

    context 'when all the dependants ages are below the health products maximum age' do
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
                                       country_of_residence: 'United Kingdom'),
          ServiceModels::Applicant.new(name: 'Dependant',
                                       date_of_birth: 39.years.ago,
                                       relationship: 'child',
                                       nationality: 'British',
                                       country_of_residence: 'United Kingdom')
        ]
      end

      it 'returns true' do
        expect(suitable_health_product_policy.allowed?(health_product)).to be true
      end
    end

    context 'when any of the dependants ages are over the products maximum age' do
      let(:applicants) do
        [
          ServiceModels::Applicant.new(name: 'Main Applicant',
                                       date_of_birth: 80.years.ago,
                                       relationship: 'self',
                                       nationality: 'British',
                                       country_of_residence: 'United Kingdom'),
          ServiceModels::Applicant.new(name: 'Dependant',
                                       date_of_birth: 81.years.ago,
                                       relationship: 'spouse',
                                       nationality: 'British',
                                       country_of_residence: 'United Kingdom'),
          ServiceModels::Applicant.new(name: 'Dependant',
                                       date_of_birth: 39.years.ago,
                                       relationship: 'child',
                                       nationality: 'British',
                                       country_of_residence: 'United Kingdom')
        ]
      end

      it 'returns false' do
        expect(suitable_health_product_policy.allowed?(health_product)).to be false
      end
    end
  end
end
