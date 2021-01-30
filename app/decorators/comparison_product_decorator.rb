# frozen_string_literal: true

class ComparisonProductDecorator < SimpleDelegator
  def product_details
    { insurer: insurer.id, product: product.id, product_modules: product_module_ids }.to_json
  end

  private

  def product_module_ids
    product_modules.map(&:id)
  end
end
