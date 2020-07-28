require 'rails_helper'

RSpec.describe Insurer, type: :model do
  subject(:insurer) { create(:insurer) }

  before { create(:insurer) }

  it { expect(insurer).to validate_presence_of :name }
  it { expect(insurer).to validate_uniqueness_of(:name).case_insensitive }
end
