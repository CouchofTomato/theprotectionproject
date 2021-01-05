class StaticPagesController < ApplicationController
  def home
    @insurers = Insurer.all.size
    @products = Product.all.size
    @product_modules = ProductModule.all.size
    @product_module_benefits = ProductModule.all.size
    @benefits = Benefit.all.size
  end
end
