require 'rails_helper'

RSpec.describe Benefit, type: :model do
  subject(:benefit) { create(:benefit) }

  it { expect(benefit).to validate_presence_of :name }
  it { expect(benefit).to validate_uniqueness_of(:name).case_insensitive.scoped_to(:category) }
  it { expect(benefit).to validate_presence_of :category }

  it do
    expect(benefit).to define_enum_for(:category)
      .with_values(inpatient: 0, outpatient: 1, therapists: 2,
                   medicines_and_appliances: 3, wellness: 4,
                   evacuation_and_repatriation: 5, maternity: 6,
                   dental: 7, optical: 8, additional: 9)
  end

  describe '.by_name' do
    let(:first_benefit) { described_class.find_by(name: 'accomodation') }

    before do
      create(:benefit, name: 'surgery', category: 'inpatient')
      create(:benefit, name: 'accomodation', category: 'inpatient')
      create(:benefit, name: 'evacuation', category: 'evacuation_and_repatriation')
    end

    it 'returns all benefits ordered by name' do
      expect(described_class.by_name.first).to eq first_benefit
    end
  end
end
