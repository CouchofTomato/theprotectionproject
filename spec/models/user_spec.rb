require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'abilities' do
    subject(:ability) { Ability.new(user) }

    context 'when an admin user' do
      let(:user) { create(:admin_user) }

      it { is_expected.to be_able_to(:invite, described_class) }
    end

    context 'when not an admin user' do
      let(:user) { create(:user) }

      it { is_expected.not_to be_able_to(:invite, described_class) }
    end
  end
end
