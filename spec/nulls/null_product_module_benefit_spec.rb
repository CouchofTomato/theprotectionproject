require 'rails_helper'

RSpec.describe NullProductModuleBenefit do
  subject(:null_product_module_benefit) { described_class.new }

  describe('#icon') do
    it 'returns the HTML for the fontawesome red cross' do
      expect(null_product_module_benefit.icon).to eq "<span class='icon'><i class='fa fa-times red-cross'></i></span>"
    end
  end

  describe('#benefit_limit') do
    it 'returns Not covered' do
      expect(null_product_module_benefit.benefit_limit).to eq 'Not covered'
    end
  end

  describe('#explanation_of_benefit') do
    it 'returns Not Covered' do
      expect(null_product_module_benefit.explanation_of_benefit).to eq 'Not Covered'
    end
  end

  describe 'benefit_status' do
    it 'returns not covered' do
      expect(null_product_module_benefit.benefit_status).to eq 'not covered'
    end
  end
end
