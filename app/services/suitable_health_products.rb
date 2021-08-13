class SuitableHealthProducts
  def self.match(health_products, applicants, required_coverages)
    new(health_products, applicants, required_coverages).match
  end

  def initialize(health_products, applicants, required_coverages)
    @health_products = health_products
    @applicants = applicants
    @required_coverages = required_coverages
    @policy = SuitableHealthProductPolicy.new(required_coverages, applicants)
  end

  def match
    filtered_health_products.uniq do |health_product|
      health_product.insurer && health_product.product && health_product.product_modules
    end
  end

  private

  attr_reader :health_products, :applicants, :required_coverages, :policy

  def filtered_health_products
    health_products.filter_map do |health_product|
      if policy.allowed?(health_product)
        ComparisonProduct.new(
          insurer: health_product.insurer,
          product: health_product.product,
          product_modules: product_modules_with_required_coverage_areas(health_product.product_modules)
        )
      end
    end
  end

  def product_modules_with_required_coverage_areas(product_modules)
    product_modules.reject { |product_module| (product_module.coverage_areas.map(&:category) & required_coverages).empty? }
  end
end
