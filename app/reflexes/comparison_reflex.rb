# frozen_string_literal: true

class ComparisonReflex < ApplicationReflex
  def products(insurer_id, customer_type)
    @products = Insurer.find(insurer_id).products.where(customer_type: customer_type)
    morph '#product-select-wrapper', render(partial: 'selection_form_products', locals: { products: @products })
  end

  def product_modules(product_id)
    @product_module_categories = ProductModule.categories.keys
    @product_modules = Product.find(product_id).product_modules
    morph '#product-modules', render(partial: 'selection_form_product_modules',
                                     locals: { product_module_categories: @product_module_categories,
                                               product_modules: @product_modules })
  end

  def selected_products(selection, options)
    @comparison_products = decorated_comparison_products(selection)
    @options = options
  end

  def set_options(selection, options)
    @comparison_products = decorated_comparison_products(selection)
    @options = options
    morph '#excel-export', render(
      partial: 'excel_export',
      locals: { comparison_products: @comparison_products, options: @options }
    )
  end

  private

  def decorated_comparison_products(selection)
    @comparison_products = selection.map do |product|
      ComparisonProductDecorator.new(
        comparison_product(product['insurer'], product['product'], product['product_modules'])
      )
    end
  end

  def comparison_product(insurer, product, product_modules)
    ComparisonProduct.new(
      Insurer.find(insurer),
      Product.find(product),
      ProductModule.includes(product_module_benefits: :benefit)
      .find(product_modules)
    )
  end
end
