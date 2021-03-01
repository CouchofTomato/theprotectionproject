require 'rails_helper'

RSpec.describe ProductModule, type: :model do
  subject(:product_module) { create(:product_module) }

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
  it { expect(product_module).to have_many(:linked_product_modules).dependent(:destroy) }
  it { expect(product_module).to have_many(:linked_modules).through(:linked_product_modules) }
  it { expect(product_module).to have_many(:coverage_areas) }
  it { expect(product_module).to accept_nested_attributes_for(:product_module_benefits) }

  describe '.core_modules' do
    let(:core_modules) { create_list(:product_module, 3) }
    let(:outpatient_modules) { create_list(:product_module, 3, category: 'outpatient') }

    before do
      create_list(:product_module, 3, category: 'outpatient')
    end

    it 'returns a relation with only those ProductModules with a core category' do
      expect(described_class.core_modules).to match_array(core_modules)
    end

    it 'does not include any modules that do not have a core category' do
      expect(described_class.core_modules).not_to match_array(outpatient_modules)
    end
  end
end
