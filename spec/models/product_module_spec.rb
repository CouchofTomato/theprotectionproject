require 'rails_helper'

RSpec.describe ProductModule, type: :model do
  before { create(:product_module) }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive.scoped_to(:category) }
  it { is_expected.to validate_presence_of :category }
  it { is_expected.to validate_inclusion_of(:category).in_array(ProductModule::CATEGORIES) }
  it { is_expected.to validate_presence_of :sum_assured }
  it { is_expected.to allow_value('USD 5,00 | GBP 6,00 | EUR 7,00').for(:sum_assured) }
  it { is_expected.not_to allow_value('USD 5,00 | GBP 6,00 | EUR 7,00 | TNT 5,00').for(:sum_assured) }
end
