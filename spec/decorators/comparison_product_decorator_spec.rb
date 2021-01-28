require 'rails_helper'

RSpec.describe ComparisonProductDecorator do
  subject(:comparison_product_decorator) { described_class.new(comparison_product) }

  let(:comparison_product) { ComparisonProduct.new(insurer, product, product_modules) }
  let(:insurer) { create(:insurer, name: 'BUPA Global', id: 5) }
  let(:product) { create(:product, name: 'Lifeline', insurer: insurer, id: 10) }
  let(:product_modules) { [create(:product_module, name: 'Gold', product: product, id: 15)] }

  describe('#product_details') do
    # rubocop:disable Style/StringLiterals
    let(:product_details_json) { "{\"insurer\":5,\"product\":10,\"product_modules\":[15]}" }
    # rubocop:enable Style/StringLiterals

    it 'renders the insurer id, product id, and product_module ids as json' do
      expect(comparison_product_decorator.product_details).to eq product_details_json
    end
  end
end
