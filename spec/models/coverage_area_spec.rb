require 'rails_helper'

RSpec.describe CoverageArea, type: :model do
  subject(:coverage_area) { create(:coverage_area) }

  it { expect(coverage_area).to belong_to :product_module }
  it { expect(coverage_area).to validate_uniqueness_of(:category).ignoring_case_sensitivity.scoped_to(:product_module_id) }

  it do
    expect(coverage_area).to define_enum_for(:category)
      .with_values(inpatient: 0, outpatient: 1, medicines_and_appliances: 3, maternity: 4,
                   evacuation_and_repatriation: 5, wellness: 6, dental: 7, optical: 8)
  end
end
