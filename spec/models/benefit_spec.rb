require 'rails_helper'

RSpec.describe Benefit, type: :model do
  before { create(:benefit) }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive.scoped_to(:category) }
  it { is_expected.to validate_presence_of :category }
  it { is_expected.to validate_inclusion_of(:category).in_array(Benefit::CATEGORIES) }
end
