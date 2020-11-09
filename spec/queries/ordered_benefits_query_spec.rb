require 'rails_helper'

RSpec.describe OrderedBenefitsQuery do
  subject(:ordered_benefits) { described_class }

  before do
    create_list(:benefit, 5)
  end

  describe '.all' do
    context 'with default arguments' do
      let(:sorted_benefits) { Benefit.all.sort_by(&:name) }

      it 'orders the benefits by name' do
        expect(ordered_benefits.all).to eq sorted_benefits
      end
    end
  end
end
