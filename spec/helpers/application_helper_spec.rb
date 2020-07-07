require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe '#bulma_class_for' do
    context 'when the type is notice' do
      let(:flash_type) { 'notice' }

      it 'returns the bulma success class' do
        expect(helper.bulma_class_for(flash_type)).to eql 'is-success'
      end
    end

    context 'when the type is alert' do
      let(:flash_type) { 'alert' }

      it 'returns the bulma danger class' do
        expect(helper.bulma_class_for(flash_type)).to eql 'is-danger'
      end
    end
  end
end
