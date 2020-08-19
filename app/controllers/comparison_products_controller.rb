class ComparisonProductsController < ApplicationController
  def create
    @insurer = @insurer.find(params[:insurer])
    @product = @product.find(params[:product])
    @product_modules = ProductModule
                       .includes(product_module_benefits: :benefit)
                       .where(id: selected_modules(@comparison_products['product_modules']))
  end

  private

  def selected_modules(modules)
    modules.values.flatten
  end
end
