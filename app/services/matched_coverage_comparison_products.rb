class MatchedCoverageComparisonProducts
  def self.match(required_coverages, comparison_products)
    new(required_coverages, comparison_products).match
  end

  def initialize(required_coverages, comparison_products)
    @required_coverages = required_coverages
    @comparison_products = comparison_products
  end

  def match
    filtered_comparison_products.uniq do |suitable_plan|
      suitable_plan.insurer && suitable_plan.product && suitable_plan.product_modules
    end
  end

  private

  attr_reader :required_coverages, :comparison_products

  def filtered_comparison_products
    comparison_products.filter_map do |comparison_product|
      if SuitableHealthProductPolicy.new(comparison_product, required_coverages).allowed?
        ComparisonProduct.new(
          insurer: comparison_product.insurer,
          product: comparison_product.product,
          product_modules: product_modules_with_required_coverage_areas(comparison_product.product_modules)
        )
      end
    end
  end

  def product_modules_with_required_coverage_areas(product_modules)
    product_modules.reject { |product_module| (product_module.coverage_areas.map(&:category) & required_coverages).empty? }
  end
end
