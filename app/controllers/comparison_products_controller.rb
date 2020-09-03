class ComparisonProductsController < ApplicationController
  def create
    @insurer = Insurer.find(params[:comparison_product][:insurer])
    @product = Product.find(params[:comparison_product][:product])
    @product_modules = ProductModule
                       .includes(product_module_benefits: :benefit)
                       .where(id: params[:comparison_product][:product_modules])
  end
end
