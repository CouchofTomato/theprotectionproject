require 'rails_helper'

RSpec.describe Insurer, type: :model do
  before { create :insurer }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
end
