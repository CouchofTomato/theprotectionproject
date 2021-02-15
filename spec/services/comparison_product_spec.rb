require 'rails_helper'

RSpec.describe ComparisonProduct do
  subject(:comparison_product) do
    described_class.new(insurer: insurer, product: product, product_modules: product_modules)
  end

  let(:insurer) { create(:insurer, name: 'BUPA Global') }
  let(:product) { create(:product, name: 'Lifeline', insurer: insurer) }
  let(:product_modules) { [create(:product_module, name: 'Gold', product: product)] }

  describe('#product_module_names') do
    context('with one product module') do
      it('returns the name of the product module') do
        expect(comparison_product.product_module_names).to eq 'Gold'
      end
    end

    context('with more than one product module') do
      let(:product_modules) do
        [
          create(:product_module, name: 'Gold', product: product),
          create(:product_module, name: 'Silver', product: product)
        ]
      end

      it('returns the name of the product modules joined with a +') do
        expect(comparison_product.product_module_names).to eq 'Gold + Silver'
      end
    end
  end

  describe('#overall_sum_assured') do
    let(:product_modules) do
      [
        create(:product_module, name: 'Gold', product: product),
        create(:product_module, name: 'Silver',
                                category: 'outpatient',
                                sum_assured: 'USD 2,000,000 | EUR 2,200,000 | GBP 1,500,000',
                                product: product)
      ]
    end

    it('returns the sum assured of the core module selected') do
      expect(comparison_product.overall_sum_assured).to eq 'USD 3,000,000 | EUR 3,200,000 | GBP 2,500,000'
    end
  end

  describe('#module_benefits') do
    let(:product_modules) do
      [
        create(:product_module, name: 'Gold', product: product) do |product_module|
          create(:product_module_benefit, product_module: product_module)
        end,
        create(:product_module, name: 'Silver', product: product) do |product_module|
          create(:product_module_benefit, benefit_status: 'capped_benefit', explanation_of_benefit: 'Paid in full for 30 days',
                                          product_module: product_module)
        end
      ]
    end
    let(:module_benefits) do
      a_collection_including(
        an_object_having_attributes(benefit_status: 'paid_in_full',
                                    benefit_limit: 'USD 1,000,000 | EUR 1,000,000 | GBP 850,000',
                                    explanation_of_benefit: 'Within overall limit'),
        an_object_having_attributes(benefit_status: 'capped_benefit',
                                    benefit_limit: 'USD 1,000,000 | EUR 1,000,000 | GBP 850,000',
                                    explanation_of_benefit: 'Paid in full for 30 days')
      )
    end

    it('returns all the product modules benefits of the selected product modules in one array') do
      expect(comparison_product.module_benefits).to match(module_benefits)
    end

    context('when multiple module benefits have the same benefit association') do
      let(:benefit) { create(:benefit, name: 'accomodation', category: 'inpatient') }
      let(:product_modules) do
        [
          create(:product_module, name: 'Gold', product: product) do |product_module|
            create(:product_module_benefit, benefit_status: 'paid_in_full',
                                            explanation_of_benefit: 'Paid in full',
                                            product_module: product_module,
                                            benefit_weighting: 0,
                                            benefit: benefit)
          end,
          create(:product_module, name: 'Silver', product: product) do |product_module|
            create(:product_module_benefit, benefit_status: 'capped_benefit',
                                            explanation_of_benefit: 'Paid in full for 30 days',
                                            product_module: product_module,
                                            benefit_weighting: 1,
                                            benefit: benefit)
          end
        ]
      end

      it 'keeps the module benefit with the higher weighting' do
        expect(comparison_product.module_benefits).to include(
          an_object_having_attributes(benefit_status: 'capped_benefit',
                                      benefit_limit: 'USD 1,000,000 | EUR 1,000,000 | GBP 850,000',
                                      explanation_of_benefit: 'Paid in full for 30 days')
        )
      end

      it 'removes the module benefit with the lower weighting' do
        expect(comparison_product.module_benefits).not_to include(
          an_object_having_attributes(benefit_status: 'paid_in_full',
                                      explanation_of_benefit: 'Paid in full')
        )
      end
    end
  end

  describe '#module_benefit' do
    let(:product_modules) do
      [
        create(:product_module, name: 'Gold', product: product) do |product_module|
          product_module.product_module_benefits << product_module_benefit
        end
      ]
    end
    let(:product_module_benefit) do
      create(:product_module_benefit) do |product_module_benefit|
        benefit = create(:benefit, id: 1)
        product_module_benefit.benefit = benefit
      end
    end

    context 'with a product module id containing a benefit id of the passed in argument' do
      let(:benefit_id) { 1 }

      it 'returns the product module' do
        expect(comparison_product.module_benefit(benefit_id)).to eq product_module_benefit
      end
    end

    context 'when there is no matching product module benefit' do
      let(:benefit_id) { 2 }

      it 'returns a NullProductModuleBenefit' do
        expect(comparison_product.module_benefit(benefit_id)).to be_kind_of NullProductModuleBenefit
      end
    end
  end

  describe('#insurer_name') do
    it 'delegates name to the insurer' do
      expect(comparison_product.insurer_name).to eq 'BUPA Global'
    end
  end

  describe('#product_name') do
    it 'delegates name to the product' do
      expect(comparison_product.product_name).to eq 'Lifeline'
    end
  end
end
