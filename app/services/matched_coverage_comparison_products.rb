class MatchedCoverageComparisonProducts
  def self.match(comparison_products, **args)
    new(comparison_products, **args).match
  end

  def initialize(comparison_products, **args)
    @comparison_products = comparison_products
    @required_coverages = args[:required_coverages]
    @args = args
  end

  def match
    filtered_comparison_products.uniq do |suitable_plan|
      suitable_plan.insurer && suitable_plan.product && suitable_plan.product_modules
    end
  end

  private

  attr_reader :required_coverages, :comparison_products, :args

  def filtered_comparison_products
    comparison_products.filter_map do |comparison_product|
      if SuitableHealthProductPolicy.new(comparison_product, **args).allowed?
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
