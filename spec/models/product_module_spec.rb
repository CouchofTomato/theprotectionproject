require 'rails_helper'

RSpec.describe ProductModule, type: :model do
  subject(:product_module) { create(:product_module) }

  before { create(:product_module) }

  it { expect(product_module).to validate_presence_of :name }
  it { expect(product_module).to validate_uniqueness_of(:name).case_insensitive.scoped_to(:category) }
  it { expect(product_module).to validate_presence_of :category }
  it { expect(product_module).to validate_presence_of :sum_assured }
  it { expect(product_module).to allow_value('USD 5,00 | GBP 6,00 | EUR 7,00').for(:sum_assured) }
  it { expect(product_module).not_to allow_value('USD 5,00 | GBP 6,00 | EUR 7,00 | TNT 5,00').for(:sum_assured) }

  it do
    expect(product_module).to define_enum_for(:category)
      .with_values(%w[core outpatient medicines_and_appliances wellness
                      maternity dental_and_optical evacuation_and_repatriation])
  end
end
