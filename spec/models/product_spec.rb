require 'rails_helper'

RSpec.describe Product, type: :model do
  subject(:product) { create(:product) }

  before { create(:product) }

  it { expect(product).to belong_to :insurer }
  it { expect(product).to validate_presence_of :name }
  it { expect(product).to validate_uniqueness_of(:name).case_insensitive }
  it { expect(product).to validate_presence_of :insurer }
  it { expect(product).to have_many(:product_modules).dependent(:destroy) }
end
