class ComparisonProduct
  attr_reader :insurer, :product, :product_modules

  def initialize(insurer, product, product_modules)
    @insurer = insurer
    @product = product
    @product_modules = product_modules
  end

  def product_module_names
    product_modules.map(&:name).join(' + ')
  end

  def overall_sum_assured
    product_modules.find { |product_module| product_module.category == 'core' }
                   .sum_assured
  end

  def module_benefits
    product_modules.map(&:product_module_benefits).flatten
  end
end
