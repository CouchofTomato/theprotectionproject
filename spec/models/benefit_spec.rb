require 'rails_helper'

RSpec.describe Benefit, type: :model do
  subject(:benefit) { create(:benefit) }

  before { create(:benefit) }

  it { expect(benefit).to validate_presence_of :name }
  it { expect(benefit).to validate_uniqueness_of(:name).case_insensitive.scoped_to(:category) }
  it { expect(benefit).to validate_presence_of :category }

  it do
    expect(benefit).to define_enum_for(:category)
      .with_values(%w[inpatient outpatient therapists medicines_and_appliances wellness
                      evacuation_and_repatriation maternity dental optical additional])
  end
end
