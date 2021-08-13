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

  describe '#svg_icon' do
    context 'when the provided filename does not exist' do
      let(:filename) { 'bad_filename' }

      it 'returns nil' do
        expect(helper.svg_icon(filename)).to be_nil
      end
    end

    context 'when the provided filename does exist' do
      let(:filename) { 'good_filename' }
      let(:svg) { '<svg>test svg</svg>' }

      before do
        allow(File).to receive(:exist?).and_return true
        allow(File).to receive(:read).and_return svg
      end

      it 'returns the svg in an html safe way' do
        expect(helper.svg_icon(filename)).to eq '<svg>test svg</svg>'
      end
    end
  end
end
