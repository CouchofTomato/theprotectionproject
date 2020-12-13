require 'rails_helper'

RSpec.describe ProductModule, type: :model do
  subject(:product_module) { create(:product_module) }

  before { create(:product_module) }

  it { expect(product_module).to validate_presence_of :name }
  it { expect(product_module).to validate_uniqueness_of(:name).case_insensitive.scoped_to(%i[category product_id]) }
  it { expect(product_module).to validate_presence_of :category }
  it { expect(product_module).to validate_presence_of :sum_assured }

  it do
    expect(product_module).to define_enum_for(:category)
      .with_values(core: 0, outpatient: 1, medicines_and_appliances: 2, wellness: 3,
                   maternity: 4, dental_and_optical: 5, evacuation_and_repatriation: 6)
  end

  it { expect(product_module).to have_many(:product_module_benefits).dependent(:destroy) }
  it { expect(product_module).to accept_nested_attributes_for(:product_module_benefits) }
end
