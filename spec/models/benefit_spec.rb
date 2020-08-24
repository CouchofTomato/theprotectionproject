require 'rails_helper'

RSpec.describe Benefit, type: :model do
  subject(:benefit) { create(:benefit) }

  it { expect(benefit).to validate_presence_of :name }
  it { expect(benefit).to validate_uniqueness_of(:name).case_insensitive.scoped_to(:category) }
  it { expect(benefit).to validate_presence_of :category }

  it do
    expect(benefit).to define_enum_for(:category)
      .with_values(['inpatient', 'outpatient', 'therapists', 'medicines and appliances',
                    'wellness', 'evacuation and repatriation', 'maternity', 'dental',
                    'optical', 'additional'])
  end

  describe '.grouped_by_category' do
    before do
      create(:benefit, name: 'surgery', category: 'inpatient')
      create(:benefit, name: 'accomodation', category: 'inpatient')
      create(:benefit, name: 'evacuation', category: 'evacuation and repatriation')
    end

    it 'returns a hash of benefits grouped by their category' do
      expect(described_class.grouped_by_category).to match(
        'inpatient' => a_collection_including(
          an_object_having_attributes(name: 'accomodation'),
          an_object_having_attributes(name: 'surgery')
        ),
        'evacuation and repatriation' => a_collection_including(
          an_object_having_attributes(name: 'evacuation')
        )
      )
    end
  end

  describe '.ordered_by_name' do
    let(:first_benefit) { described_class.find_by(name: 'accomodation') }

    before do
      create(:benefit, name: 'surgery', category: 'inpatient')
      create(:benefit, name: 'accomodation', category: 'inpatient')
      create(:benefit, name: 'evacuation', category: 'evacuation and repatriation')
    end

    it 'returns all benefits ordered by name' do
      expect(described_class.ordered_by_name.first).to eq first_benefit
    end
  end
end
