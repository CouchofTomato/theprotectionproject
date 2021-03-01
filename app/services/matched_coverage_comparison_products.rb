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
      if includable_comparison_product?(comparison_product)
        ComparisonProduct.new(
          insurer: comparison_product.insurer,
          product: comparison_product.product,
          product_modules: product_modules_with_required_coverage_areas(comparison_product.product_modules)
        )
      end
    end
  end

  def includable_comparison_product?(comparison_product)
    comparison_product.coverage_areas?(required_coverages) && core_module_outpatient_check_valid?(comparison_product)
  end

  def core_module_outpatient_check_valid?(match)
    return true if required_coverages.include? 'outpatient'

    core_module = match.product_modules.find { _1.category == 'core' }
    core_module.coverage_areas.none? { _1.category == 'outpatient' }
  end

  def product_modules_with_required_coverage_areas(product_modules)
    product_modules.reject { |product_module| (product_module.coverage_areas.map(&:category) & required_coverages).empty? }
  end
end
