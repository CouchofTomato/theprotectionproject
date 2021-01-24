# frozen_string_literal: true

class ComparisonReflex < ApplicationReflex
  def products(insurer_id, customer_type)
    @products = Insurer.find(insurer_id).products.where(customer_type: customer_type)
    morph '#product-select', render(partial: 'selection_form_products', locals: { products: @products })
  end

  def product_modules(product_id)
    @product_module_categories = ProductModule.categories.keys
    @product_modules = Product.find(product_id).product_modules
    morph '#product-modules', render(partial: 'selection_form_product_modules',
                                     locals: { product_module_categories: @product_module_categories,
                                               product_modules: @product_modules })
  end

  def selected_products(selection)
    @comparison_products = selection.map do |product|
      ComparisonProduct.new(Insurer.find(product['insurer']), Product.find(product['product']),
                            ProductModule.includes(product_module_benefits: :benefit)
      .find(product['product_modules']))
    end
  end
end
