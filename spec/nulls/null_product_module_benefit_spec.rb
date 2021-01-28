require 'rails_helper'

RSpec.describe NullProductModuleBenefit do
  subject(:null_product_module_benefit) { described_class.new }

  describe '#benefit_limit' do
    it 'returns Not covered' do
      expect(null_product_module_benefit.benefit_limit).to eq 'Not covered'
    end
  end

  describe '#explanation_of_benefit' do
    it 'returns Not Covered' do
      expect(null_product_module_benefit.explanation_of_benefit).to eq 'Not Covered'
    end
  end

  describe 'benefit_status' do
    it 'returns not covered' do
      expect(null_product_module_benefit.benefit_status).to eq 'not_covered'
    end
  end

  describe 'full_benefit_coverage' do
    it 'returns the explanation_of_benefit' do
      expect(null_product_module_benefit.full_benefit_coverage).to eq 'Not Covered'
    end
  end
end
