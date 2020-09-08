class ComparisonProduct
  attr_reader :insurer, :product, :product_modules

  def initialize(insurer, product, product_modules)
    @insurer = insurer
    @product = product
    @product_modules = product_modules
  end
end
